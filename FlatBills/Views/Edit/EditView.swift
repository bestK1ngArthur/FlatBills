//
//  EditView.swift
//  FlatBills
//
//  Created by Artem on 28.12.2021.
//

import SwiftUI

struct EditView: View {
    @ObservedObject var model: EditViewModel
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    DatePicker(selection: $model.date, displayedComponents: [.date]) {
                        Text("Date")
                    }
                }
                
                Section("Utilities") {
                    ForEach($model.utilities) { $item in
                        EditItemView(item: $item)
                    }
                }
                .headerProminence(.increased)

                Section("Maintenance") {
                    ForEach($model.maintenance) { $item in
                        EditItemView(item: $item)
                    }
                }
                .headerProminence(.increased)

                Section("Other") {
                    ForEach($model.other) { $item in
                        EditItemView(item: $item)
                    }
                }
                .headerProminence(.increased)
                
                Section {
                    HStack {
                        Text("Total Price")
                        Spacer()
                        TextField("0", value: $model.totalPrice, formatter: .price)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                            .font(.headline)
                    }
                }
            }
            .navigationTitle("Edit")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        model.cancel()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        model.save()
                    }
                }
            }
        }
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
