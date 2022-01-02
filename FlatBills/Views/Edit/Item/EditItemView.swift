//
//  EditItemView.swift
//  FlatBills
//
//  Created by Artem on 02.01.2022.
//

import SwiftUI

struct EditItemView: View {
    @Binding var item: EditItem

    var body: some View {
        VStack {
            TextField("Name", text: $item.name)
                .font(.headline)
            HStack(spacing: 4) {
                TextField("0", value: $item.value, format: .number)
                    .keyboardType(.decimalPad)
                    .fixedSize()
                Picker("Unit", selection: $item.unit) {
                    ForEach(Metric.Unit.allCases) { unit in
                        Text(unit.rawValue).tag(unit)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                Text("x")
                    .foregroundColor(Color.secondary)
                TextField("Tariff", value: $item.tariff, formatter: .price)
                    .keyboardType(.decimalPad)
                    .fixedSize()
                Spacer()
                TextField("Total", value: $item.total, formatter: .price)
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
                    .font(.headline)
            }
        }
        .padding(.vertical, 4)
    }
}

private extension Formatter {
    static let price: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.currencySymbol = "₽"
        return formatter
    }()
}
