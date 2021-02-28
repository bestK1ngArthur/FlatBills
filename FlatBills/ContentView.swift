//
//  ContentView.swift
//  FlatBills
//
//  Created by Artem Belkov on 28.02.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct BillView: View {
    let bill: Bill
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(bill.dateString).font(.headline)
                .padding(.bottom, 8)
            
            Text("Utilities").bold()
                .padding(.bottom, 2)

            ForEach(bill.utilities) { utility in
                Text("\(utility.name): \(Int(utility.total))₽")
                    .padding(.bottom, 2)
            }
                        
            Text("Maintenance").bold()
                .padding(.top, 6)
                .padding(.bottom, 2)

            ForEach(bill.maintenance) { maintenance in
                Text("\(maintenance.name): \(Int(maintenance.total))₽")
                    .padding(.bottom, 2)
            }
            
            Text("Other").bold()
                .padding(.top, 6)
                .padding(.bottom, 2)

            ForEach(bill.other) { other in
                Text("\(other.name): \(Int(other.total))₽")
                    .padding(.bottom, 2)
            }
                        
            (Text("Total: ") + Text("\(Int(bill.total))₽").bold())
                .padding(.top, 8)
        }
    }
}
