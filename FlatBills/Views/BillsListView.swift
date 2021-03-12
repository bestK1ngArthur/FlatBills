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
                        BillView(bill: bill)
                            .padding(8)
                    }
                    .listRowInsets(.init(top: 6, leading: 6, bottom: 6, trailing: 0))
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
