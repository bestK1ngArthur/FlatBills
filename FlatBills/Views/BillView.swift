//
//  BillView.swift
//  FlatBills
//
//  Created by Artem Belkov on 12.03.2021.
//

import SwiftUI

struct BillView: View {
    let bill: Bill
    
    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(bill.dateString).font(.title3).bold()
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
