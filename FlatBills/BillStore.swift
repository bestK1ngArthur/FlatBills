//
//  BillStore.swift
//  FlatBills
//
//  Created by Artem Belkov on 28.02.2021.
//

import Foundation
import Combine

class BillStore: ObservableObject {
    @Published var bills: [Bill] {
        didSet {
            try? UserDefaults.default.setObject(bills, forKey: "bills")
        }
    }
    
    init() {
        let bills = (try? UserDefaults.default.getObject(forKey: "bills", castTo: [Bill].self)) ?? []
        self.bills = bills.sorted { first, second in
            first.date > second.date
        }
    }
}
