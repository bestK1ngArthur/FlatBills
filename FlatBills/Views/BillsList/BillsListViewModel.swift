//
//  BillsListViewModel.swift
//  FlatBills
//
//  Created by Artem on 28.12.2021.
//

import Foundation

final class BillsListViewModel: ObservableObject {
    @Published var bills: [Bill] = []
    @Published var isFileImporterPresented = false
    
    @Dependency var billStore: IBillStore
    @Dependency var billParser: IBillParser
    
    init() {
        updateBills()
    }
    
    func removeBill(at indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        billStore.removeBill(at: index)
        
        updateBills()
    }
    
    func add() {
        isFileImporterPresented = true
    }
    
    func handleImportResult(_ result: Result<URL, Error>) {
        guard
            case let .success(url) = result,
            let bill = billParser.parse(from: url) else { return }
        
        billStore.saveBill(bill)
    }
    
    private func updateBills() {
        bills = billStore.getSavedBills()
    }
}
