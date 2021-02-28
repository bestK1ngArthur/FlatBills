//
//  BillParser.swift
//  FlatBills
//
//  Created by Artem Belkov on 28.02.2021.
//

import PDFKit

class BillParser {
    static let `default` = BillParser()
    
    func parse(from url: URL) -> Bill? {
        guard let document = PDFDocument(url: url)?.string else {
            return nil
        }
        
        let rows = document.components(separatedBy: "\n")
        
        let utilitiesAnchors = ["ОТОПЛЕНИЕ Гкал", "ХОЛОДНОЕ В/С м3", "ГОРЯЧЕЕ В/С м3", "ВОДООТВЕДЕНИЕ м3", "ЭЛЕКТРОСНАБЖЕНИЕ: кВт.ч"]
        let utilitiesMetrics: [Metric] = rows.compactMap { row in
            for anchor in utilitiesAnchors where row.contains(anchor) {
                return parseUtilityMetric(row)
            }
            
            return nil
        }

        let maintenanceAnchors = ["ЭЛЕКТРОСНАБЖЕНИЕ ОДН м2", "СОДЕРЖАНИЕ И РЕМОНТ м2"]
        let maintenanceMetrics: [Metric] = rows.compactMap { row in
            for anchor in maintenanceAnchors where row.contains(anchor) {
                return parseMaintenanceMetric(row)
            }
            
            return nil
        }
        
        let otherAnchors = ["Услуги охраны периметра м2"]
        let otherMetrics: [Metric] = rows.compactMap { row in
            for anchor in otherAnchors where row.contains(anchor) {
                return parseOtherMetric(row)
            }
            
            return nil
        }

        var total: Price?
        for row in rows where row.contains("Итого к оплате, руб.") {
            total = Price(row.components(separatedBy: " ").last!)
        }
        
        var date: Date?
        for row in rows where row.contains("Дата последней оплаты") {
            let string = row
                .replacingOccurrences(of: " ", with: "")
                .components(separatedBy: "оплаты")
                .last!
            date = dateFormatter.date(from: string)
        }
        
        return .init(
            date: date ?? .init(),
            utilities: utilitiesMetrics,
            maintenance: maintenanceMetrics,
            other: otherMetrics,
            total: total ?? 0
        )
    }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()
    
    private func parseUtilityMetric(_ raw: String) -> Metric? {
        let name: String? = {
            if raw.contains("ОТОПЛЕНИЕ") { return "☀️ Heating" }
            else if raw.contains("ХОЛОДНОЕ В/С") { return "❄️ Cold water" }
            else if raw.contains("ГОРЯЧЕЕ В/С") { return "🔥 Hot water" }
            else if raw.contains("ВОДООТВЕДЕНИЕ") { return "🚽 Drainage" }
            else if raw.contains("ЭЛЕКТРОСНАБЖЕНИЕ") { return "⚡️ Power" }
            else { return nil }
        }()
        
        let unit: Metric.Unit? = {
            if raw.contains("Гкал") { return .gigaCalorie }
            else if raw.contains("м3") { return .cubicMetre }
            else if raw.contains("кВт.ч") { return .kiloWattHour }
            else { return nil }
        }()
        
        let separators = ["Гкал", "м3", "кВт.ч"]
        let values: [String] = {
            for separator in separators where raw.contains(separator) {
                return raw
                    .components(separatedBy: separator).last!
                    .components(separatedBy: " ")
                    .filter { !$0.isEmpty }
            }
            
            return []
        }()

        var formattedValues: [String] = []
        if values.count > 9 {
            var bufferValue: String?
            
            for value in values {
                if value.count == 1, value.first?.isNumber == true {
                    bufferValue = value
                    continue
                }
                
                let formattedValue = ((bufferValue ?? "") + value).replacingOccurrences(of: ",", with: ".")
                formattedValues.append(formattedValue)
                
                bufferValue = nil
            }
        } else {
            formattedValues = values.map({ value in
                value.replacingOccurrences(of: ",", with: ".")
            })
        }
        
        guard formattedValues.count == 9 else { return nil }
        
        guard let castedName = name,
              let castedUnit = unit,
              let value = Double(formattedValues[0]),
              let total = Price(formattedValues[8]) else {
            return nil
        }
        
        return .init(
            name: castedName,
            unit: castedUnit,
            value: value,
            tariff: Price(formattedValues[2]) ?? (total / value),
            total: total
        )
    }
    
    private func parseMaintenanceMetric(_ raw: String) -> Metric? {
        let name: String? = {
            if raw.contains("ЭЛЕКТРОСНАБЖЕНИЕ ОДН") { return "⚡️ Power" }
            else if raw.contains("СОДЕРЖАНИЕ И РЕМОНТ") { return "🛠 Repair" }
            else { return nil }
        }()
        
        let unit: Metric.Unit? = {
            if raw.contains("м2") { return .squareMetre }
            else { return nil }
        }()
        
        let separators = ["м2"]
        let values: [String] = {
            for separator in separators where raw.contains(separator) {
                return raw
                    .components(separatedBy: separator).last!
                    .components(separatedBy: " ")
                    .filter { !$0.isEmpty }
            }
            
            return []
        }()

        var formattedValues: [String] = []
        if values.count > 9 {
            var bufferValue: String?
            
            for value in values {
                if value.count == 1, value.first?.isNumber == true {
                    bufferValue = value
                    continue
                }
                
                let formattedValue = ((bufferValue ?? "") + value).replacingOccurrences(of: ",", with: ".")
                formattedValues.append(formattedValue)
                
                bufferValue = nil
            }
        } else {
            formattedValues = values.map({ value in
                value.replacingOccurrences(of: ",", with: ".")
            })
        }
        
        formattedValues = formattedValues.filter { value in
            Double(value) != nil || value.count == 1
        }
        
        guard formattedValues.count == 9 else { return nil }
        
        guard let castedName = name,
              let castedUnit = unit,
              let total = Price(formattedValues[8]) else {
            return nil
        }

        let individualValue = Double(formattedValues[0]) ?? 0
        let groupValue = Double(formattedValues[1]) ?? 0
        let value = individualValue + groupValue
        
        return .init(
            name: castedName,
            unit: castedUnit,
            value: value,
            tariff: Price(formattedValues[2]) ?? (total / value),
            total: total
        )
    }
    
    private func parseOtherMetric(_ raw: String) -> Metric? {
        let name: String? = {
            if raw.contains("Услуги охраны периметра") { return "🚔 Security" }
            else { return nil }
        }()
        
        let unit: Metric.Unit? = {
            if raw.contains("м2") { return .squareMetre }
            else { return nil }
        }()
        
        let separators = ["м2"]
        let values: [String] = {
            for separator in separators where raw.contains(separator) {
                return raw
                    .components(separatedBy: separator).last!
                    .components(separatedBy: " ")
                    .filter { !$0.isEmpty }
            }
            
            return []
        }()

        var formattedValues: [String] = []
        if values.count > 9 {
            var bufferValue: String?
            
            for value in values {
                if value.count == 1, value.first?.isNumber == true {
                    bufferValue = value
                    continue
                }
                
                let formattedValue = ((bufferValue ?? "") + value).replacingOccurrences(of: ",", with: ".")
                formattedValues.append(formattedValue)
                
                bufferValue = nil
            }
        } else {
            formattedValues = values.map({ value in
                value.replacingOccurrences(of: ",", with: ".")
            })
        }
        
        formattedValues = formattedValues.filter { value in
            Double(value) != nil || value.count == 1
        }
        
        guard formattedValues.count == 9 else { return nil }
        
        guard let castedName = name,
              let castedUnit = unit,
              let total = Price(formattedValues[8]) else {
            return nil
        }

        let individualValue = Double(formattedValues[0]) ?? 0
        let groupValue = Double(formattedValues[1]) ?? 0
        let value = individualValue + groupValue
        
        return .init(
            name: castedName,
            unit: castedUnit,
            value: value,
            tariff: Price(formattedValues[2]) ?? (total / value),
            total: total
        )
    }
}
