//
//  BillsListViewModel.swift
//  FlatBills
//
//  Created by Artem on 28.12.2021.
//

import Foundation
import Combine
import SwiftUI

final class ListViewModel: ObservableObject {
    @Published var sections: [Section] = []
    @Published var importedBill: Bill?
    
    @Published var isFileImporterPresented = false
    @Published var isEditPresented = false
    
    @Dependency var billStore: IBillStore
    @Dependency var billParser: IBillParser
    
    init() {
        bind()
        updateSections()
    }
    
    func removeBill(in section: Section, indexSet: IndexSet) {
        guard let index = indexSet.first else { return }
        
        let billID = section.items[index].bill.id
        billStore.removeBill(by: billID)

        updateSections()
    }
    
    func add() {
        isFileImporterPresented = true
    }
    
    func handleImportResult(_ result: Result<URL, Error>) {
        guard case let .success(url) = result else { return }
        
        let bill = billParser.parse(from: url) ?? .zero
        importedBill = bill
        isEditPresented = true
        
        updateSections()
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    private func bind() {
        $isEditPresented
            .sink { [weak self] _ in self?.updateSections() }
            .store(in: &cancellables)
    }
    
    private func updateSections() {
        let bills = billStore.getSavedBills()
        let groups = Dictionary(grouping: bills, by: { $0.date.year })
        
        sections = groups.keys.map { year in
            let items = groups[year]!.map { bill in
                Item(
                    month: DateFormatter.month.string(from: bill.date),
                    price: NumberFormatter.price.string(from: NSNumber(value: bill.totalPrice))!,
                    bill: bill
                )
            }
            
            return Section(title: "\(year)", items: items)
        }
    }
}

extension ListViewModel {
    struct Section: Identifiable {
        let title: String
        let items: [Item]
        
        var id: String { title }
    }
    
    struct Item: Identifiable {
        let month: String
        let price: String
        let bill: Bill
        
        var id: String { month }
    }
}

private extension DateFormatter {
    static let month: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
}

private extension NumberFormatter {
    static let price: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.minimumFractionDigits = 0
        formatter.currencySymbol = "₽"
        return formatter
    }()
}
