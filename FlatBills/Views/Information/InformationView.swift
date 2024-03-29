//
//  InformationView.swift
//  FlatBills
//
//  Created by Artem Belkov on 12.03.2021.
//

import SwiftUI

struct InformationView: View {
    @ObservedObject var model: InformationViewModel
    
    var body: some View {
        List {
            ForEach(model.sections) { section in
                Section(section.name) {
                    ForEach(section.items) { item in
                        HStack {
                            Text(item.name)
                            Spacer()
                            Text(item.price)
                        }
                    }
                }
                .headerProminence(.increased)
            }
            
            Section {
                HStack {
                    Text("Total")
                    Spacer()
                    Text(model.totalPrice)
                        .multilineTextAlignment(.trailing)
                        .font(.headline)
                }
            }
        }
        .navigationTitle(model.month)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    model.presentEdit()
                } label: {
                    Label("Edit", systemImage: "pencil")
                }
            }
        }
        .sheet(isPresented: $model.isEditPresented) {
            if let bill = model.bill {
                EditView(model: .init(bill, isPresented: $model.isEditPresented))
            }
        }
    }
}
