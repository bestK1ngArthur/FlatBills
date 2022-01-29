//
//  InformationViewModel.swift
//  FlatBills
//
//  Created by Artem on 02.01.2022.
//

import Foundation
import Combine

final class InformationViewModel: ObservableObject {
    @Published var bill: Bill? = nil
    @Published var month: String = ""
    @Published var sections: [Section] = []
    @Published var totalPrice: String = ""
    @Published var isEditPresented = false
    
    @Dependency var billStore: IBillStore
    
    init(_ billID: UUID) {
        self.billID = billID
        
        bind()
        updateState()
    }
    
    func presentEdit() {
        isEditPresented = true
    }
        
    private let billID: UUID
    private var cancellables = Set<AnyCancellable>()

    private func bind() {
        $isEditPresented
            .filter { $0 == false }
            .sink { [weak self] _ in self?.updateState() }
            .store(in: &cancellables)
    }
    
    private func updateState() {
        guard let bill = billStore.getSavedBill(by: billID) else {
            fatalError("Bill is nil")
        }
        
        self.bill = bill
        month = DateFormatter.date.string(from: bill.date)
        sections = {
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
        totalPrice = NumberFormatter.price.string(from: NSNumber(value: bill.totalPrice))!
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
