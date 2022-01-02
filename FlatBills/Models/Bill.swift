//
//  Bill.swift
//  FlatBills
//
//  Created by Artem Belkov on 28.02.2021.
//

import Foundation

struct Bill: Codable {
    /// ID счёта
    let id: UUID
    
    /// Дата выставления счета
    let date: Date
    
    /// Коммунальные платежи
    let utilities: [Metric]
    
    /// Содержание общих помещений
    let maintenance: [Metric]
    
    /// Прочие услуги
    let other: [Metric]
    
    /// Общая стоимость
    let totalPrice: Price
}

extension Bill {
    static var zero: Bill {
        Bill(
            id: .init(),
            date: .now,
            utilities: [
                .init(name: "☀️ Heating", unit: .gigaCalorie, value: 0, tariff: 0, total: 0),
                .init(name: "❄️ Cold water", unit: .cubicMetre, value: 0, tariff: 0, total: 0),
                .init(name: "🔥 Hot water", unit: .cubicMetre, value: 0, tariff: 0, total: 0),
                .init(name: "🚽 Drainage", unit: .cubicMetre, value: 0, tariff: 0, total: 0),
                .init(name: "⚡️ Power", unit: .kiloWattHour, value: 0, tariff: 0, total: 0)
            ],
            maintenance: [
                .init(name: "⚡️ Power", unit: .kiloWattHour, value: 0, tariff: 0, total: 0),
                .init(name: "🛠 Repair", unit: .squareMetre, value: 0, tariff: 0, total: 0)
            ],
            other: [
                .init(name: "🚔 Security", unit: .squareMetre, value: 0, tariff: 0, total: 0)
            ],
            totalPrice: 5000
        )
    }
}
