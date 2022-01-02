//
//  BillStore.swift
//  FlatBills
//
//  Created by Artem Belkov on 28.02.2021.
//

import Foundation
import Combine

protocol IBillStore {
    func getSavedBills() -> [Bill]
    func saveBill(_ bill: Bill)
    func replaceBill(_ bill: Bill, by id: UUID)
    func removeBill(by id: UUID)
}

final class BillStore: IBillStore {
    func getSavedBills() -> [Bill] {
        let savedBills = (try? UserDefaults.default.getObject(forKey: .billsKey, castTo: [Bill].self)) ?? []
        return savedBills.sorted { first, second in
            first.date > second.date
        }
    }
    
    func saveBill(_ bill: Bill) {
        var bills = getSavedBills()
        bills.append(bill)
        saveBills(bills)
    }
    
    func replaceBill(_ bill: Bill, by id: UUID) {
        var bills = getSavedBills()
        
        if let index = bills.firstIndex(where: { $0.id == id }) {
            bills.remove(at: index)
            bills.insert(bill, at: index)
        } else {
            bills.append(bill)
        }
        
        saveBills(bills)
    }
    
    func removeBill(by id: UUID) {
        var bills = getSavedBills()
        
        guard let index = bills.firstIndex(where: { $0.id == id }) else {
            return
        }
        
        bills.remove(at: index)
        saveBills(bills)
    }
    
    private func saveBills(_ bills: [Bill]) {
        try? UserDefaults.default.setObject(bills, forKey: .billsKey)
    }
}

private extension String {
    static let billsKey = "bills"
}
