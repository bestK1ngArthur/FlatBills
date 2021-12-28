//
//  DependenciesContainer.swift
//  FlatBills
//
//  Created by Artem Belkov on 02.11.2021.
//

import Foundation

final class DependenciesContainer {
    private var dependencies: [ObjectIdentifier: Any] = [:]

    func add<Dependency>(_ dependency: Dependency) {
        let key = ObjectIdentifier(Dependency.self)
        dependencies[key] = dependency as Any
    }
    
    func get<Dependency>() -> Dependency {
        let key = ObjectIdentifier(Dependency.self)
        guard let dependency = dependencies[key] as? Dependency else {
            fatalError("No dependency found for \(key)-\(Dependency.self)!")
        }
        
        return dependency
    }
}
