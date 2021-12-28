//
//  BillsListView.swift
//  FlatBills
//
//  Created by Artem Belkov on 28.02.2021.
//

import SwiftUI

struct BillsListView: View {
    @ObservedObject var model: BillsListViewModel
    
    var body: some View {
        NavigationView {
            List {
                ForEach(model.bills) { bill in
                    Group {
                        NavigationLink(destination: BillView(bill: bill)) {
                            BillView(bill: bill)
                        }
                        .padding(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowInsets(.init(top: 6, leading: 6, bottom: 6, trailing: 0))
                }
                .onDelete { model.removeBill(at: $0) }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Bills")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        model.add()
                    }  label: {
                        Label("Add", systemImage: "plus")
                    }
                }
            }
            .fileImporter(
                isPresented: $model.isFileImporterPresented,
                allowedContentTypes: [.pdf]
            ) { model.handleImportResult($0) }
        }
    }
}

struct BillsListView_Previews: PreviewProvider {
    static var previews: some View {
        BillsListView(model: .init())
    }
}
