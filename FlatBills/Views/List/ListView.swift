//
//  ListView.swift
//  FlatBills
//
//  Created by Artem Belkov on 28.02.2021.
//

import SwiftUI

struct ListView: View {
    @ObservedObject var model: ListViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(model.sections) { section in
                    Section(section.title) {
                        ForEach(section.items) { item in
                            NavigationLink {
                                InformationView(model: .init(item.bill))
                            } label: {
                                HStack {
                                    Text(item.month)
                                    Spacer()
                                    Text(item.price)
                                }
                            }

                        }
                        .onDelete { indexSet in
                            model.removeBill(in: section, indexSet: indexSet)
                        }
                    }
                    .headerProminence(.increased)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Bills")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        model.add()
                    } label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .fileImporter(
                isPresented: $model.isFileImporterPresented,
                allowedContentTypes: [.pdf]
            ) { model.handleImportResult($0) }
            .sheet(isPresented: $model.isEditPresented) {
                if let bill = model.importedBill {
                    EditView(model: .init(bill, isPresented: $model.isEditPresented))
                }
            }
        }
    }
}

struct BillsListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(model: .init())
    }
}
