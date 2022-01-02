//
//  Metric.swift
//  FlatBills
//
//  Created by Artem on 28.12.2021.
//

import Foundation

struct Metric: Codable {
    var name: String
    var unit: Unit
    var value: Double
    var tariff: Price
    var total: Price
    
    init(
        name: String,
        unit: Unit,
        value: Double,
        tariff: Price,
        total: Price
    ) {
        self.name = name
        self.unit = unit
        self.value = value
        self.tariff = tariff
        self.total = total
    }
}

extension Metric {
    enum Unit: String, Codable, CaseIterable, Identifiable {
        case gigaCalorie = "gCal"
        case squareMetre = "m3"
        case cubicMetre = "m2"
        case kiloWattHour = "kW⋅h"
        
        var id: String { rawValue }
    }
}

typealias Price = Double
