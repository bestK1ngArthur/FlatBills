//
//  BillsListView.swift
//  FlatBills
//
//  Created by Artem Belkov on 28.02.2021.
//

import SwiftUI

struct BillsListView: View {
    @ObservedObject var billsStore = BillStore()
    
    var body: some View {
        NavigationView {
            List {
                ForEach(billsStore.bills) { bill in
                    Group {
                        NavigationLink(destination: BillView(bill: bill)) {
                            BillView(bill: bill)
                        }
                        .padding(8)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .listRowInsets(.init(top: 6, leading: 6, bottom: 6, trailing: 0))
                }
                .onDelete { indexSet in
                    guard let index = indexSet.first else { return }
                    billsStore.bills.remove(at: index)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .navigationTitle("Bills")
        }
    }
}

struct BillsListView_Previews: PreviewProvider {
    static var previews: some View {
        BillsListView()
    }
}
