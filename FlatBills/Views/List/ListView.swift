//
//  ListView.swift
//  FlatBills
//
//  Created by Artem Belkov on 28.02.2021.
//

import SwiftUI
import Charts

struct ListView: View {
    @ObservedObject var model: ListViewModel
    
    var body: some View {
        NavigationView {
            List {
                if model.sections.isEmpty {
                    Section {
                        Text("No bills")
                    }
                    .headerProminence(.increased)
                }
                
                if model.prices.count > 2 {
                    Section("Chart") {
                        Chart(data: model.prices)
                            .chartStyle(
                                AreaChartStyle(.quadCurve, fill: LinearGradient(gradient: .init(colors: [Color.orange.opacity(0.8), Color.orange.opacity(0.05)]), startPoint: .top, endPoint: .bottom))
                            )
                            .frame(minHeight: 100)
                    }
                    .headerProminence(.increased)
                }

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
