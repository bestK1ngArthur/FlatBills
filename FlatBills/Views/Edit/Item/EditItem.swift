//
//  EditItem.swift
//  FlatBills
//
//  Created by Artem on 02.01.2022.
//

import SwiftUI

struct EditItem: Identifiable {
    let id = UUID()
    
    var name: String
    var unit: Metric.Unit
    var value: Double
    var tariff: Price
    var total: Price
}
