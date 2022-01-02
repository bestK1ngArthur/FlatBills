//
//  BillParserLogic.swift
//  FlatBills
//
//  Created by Artem on 28.12.2021.
//

import Foundation

protocol BillParserLogic {
    func parse(from document: String) -> Bill?
}
