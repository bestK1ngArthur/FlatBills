//
//  Dependency.swift
//  FlatBills
//
//  Created by Artem Belkov on 02.11.2021.
//

@propertyWrapper
struct Dependency<IDependency> {
    var wrappedValue: IDependency

    init() {
        self.wrappedValue = FlatBillsApp.dependencyContainer.get()
    }
}
