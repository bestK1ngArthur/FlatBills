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
    func removeBill(at index: Int)
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
    
    func removeBill(at index: Int) {
        var bills = getSavedBills()
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
