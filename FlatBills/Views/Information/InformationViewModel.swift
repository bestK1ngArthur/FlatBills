//
//  InformationViewModel.swift
//  FlatBills
//
//  Created by Artem on 02.01.2022.
//

import Foundation

final class InformationViewModel: ObservableObject {
    @Published var month: String
    @Published var sections: [Section]
    @Published var totalPrice: String
    @Published var bill: Bill
    @Published var isEditPresented = false
    
    init(_ bill: Bill) {
        self.month = DateFormatter.date.string(from: bill.date)
        self.sections = {
            let mapItem: (Metric) -> Item = { metric in
                    .init(name: metric.name,
                          price: NumberFormatter.price.string(from: NSNumber(value: metric.total))!)
            }
            
            var sections: [Section] = []
            
            if bill.utilities.isNotEmpty {
                sections.append(.init(name: "Utilities", items: bill.utilities.map(mapItem)))
            }

            if bill.maintenance.isNotEmpty {
                sections.append(.init(name: "Maintance", items: bill.maintenance.map(mapItem)))
            }
            
            if bill.other.isNotEmpty {
                sections.append(.init(name: "Other", items: bill.other.map(mapItem)))
            }
            
            return sections
        }()
        self.totalPrice = NumberFormatter.price.string(from: NSNumber(value: bill.totalPrice))!
        self.bill = bill
    }
    
    func presentEdit() {
        isEditPresented = true
    }
}

extension InformationViewModel {
    struct Section: Identifiable {
        let name: String
        let items: [Item]
        
        var id: String { name }
    }
    
    struct Item: Identifiable {
        let name: String
        let price: String
        
        var id: String { name }
    }
}

private extension DateFormatter {
    static let date: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM YYYY"
        return formatter
    }()
}

private extension NumberFormatter {
    static let price: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.currencySymbol = "₽"
        return formatter
    }()
}
