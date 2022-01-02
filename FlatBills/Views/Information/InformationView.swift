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
            EditView(model: .init(model.bill, isPresented: $model.isEditPresented))
        }
    }
}
