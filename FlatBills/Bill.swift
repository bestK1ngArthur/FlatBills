//
//  Bill.swift
//  FlatBills
//
//  Created by Artem Belkov on 28.02.2021.
//

import Foundation

struct Bill: Codable {
    let date: Date
    let utilities: [Metric]
    let maintenance: [Metric]
    let other: [Metric]
    let total: Price
    
    var dateString: String {
        Self.dateFormatter.string(from: date)
    }
    
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        return formatter
    }()
}

extension Bill: Identifiable {
    var id: String { .init(date.timeIntervalSince1970) }
}

struct Metric: Codable {
    let name: String
    let unit: Unit
    let value: Double
    let tariff: Price
    let total: Price
    
    enum Unit: String, Codable {
        case gigaCalorie = "gCal"
        case squareMetre = "m3"
        case cubicMetre = "m2"
        case kiloWattHour = "kW⋅h"
    }
}

extension Metric: Identifiable {
    var id: String { name }
}

typealias Price = Double
