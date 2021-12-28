//
//  FlatBillsApp.swift
//  FlatBills
//
//  Created by Artem Belkov on 28.02.2021.
//

import SwiftUI

@main
struct FlatBillsApp: App {
    static let dependencyContainer: DependenciesContainer = {
        let container = DependenciesContainer()
        
        let billStore: IBillStore = BillStore()
        let billParser: IBillParser = BillParser()
        
        container.add(billStore)
        container.add(billParser)
        
        return container
    }()
    
    var body: some Scene {
        WindowGroup {
            BillsListView(model: .init())
        }
    }
}
