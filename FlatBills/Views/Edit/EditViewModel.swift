//
//  EditViewModel.swift
//  FlatBills
//
//  Created by Artem on 28.12.2021.
//

import SwiftUI

final class EditViewModel: ObservableObject {
    @Published var date: Date
    @Published var utilities: [EditItem]
    @Published var maintenance: [EditItem]
    @Published var other: [EditItem]
    @Published var totalPrice: Double

    @Binding private var isPresented: Bool
    
    @Dependency var billStore: IBillStore
    
    private let billID: UUID
    
    init(_ bill: Bill, isPresented: Binding<Bool>) {
        self.date = bill.date
        
        let mapMetric: (Metric) -> EditItem = { metric in
            EditItem(
                name: metric.name,
                unit: metric.unit,
                value: metric.value,
                tariff: metric.tariff,
                total: metric.total
            )
        }
        
        self.utilities = bill.utilities.map(mapMetric)
        self.maintenance = bill.maintenance.map(mapMetric)
        self.other = bill.other.map(mapMetric)
        
        self.totalPrice = bill.totalPrice
        self._isPresented = isPresented
        self.billID = bill.id
    }
    
    func save() {
        let mapEditItem: (EditItem) -> Metric = { editItem in
            Metric(
                name: editItem.name,
                unit: editItem.unit,
                value: editItem.value,
                tariff: editItem.tariff,
                total: editItem.total
            )
        }
        
        let bill = Bill(
            id: billID,
            date: date,
            utilities: utilities.map(mapEditItem),
            maintenance: maintenance.map(mapEditItem),
            other: other.map(mapEditItem),
            totalPrice: totalPrice
        )
        
        billStore.replaceBill(bill, by: billID)
        isPresented = false
    }
    
    func cancel() {
        isPresented = false
    }
}
