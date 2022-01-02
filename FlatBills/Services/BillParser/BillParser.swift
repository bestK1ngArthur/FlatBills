//
//  BillParser.swift
//  FlatBills
//
//  Created by Artem Belkov on 28.02.2021.
//

import PDFKit

protocol IBillParser {
    func parse(from url: URL) -> Bill?
}

final class BillParser: IBillParser {
    private let logics: [BillParserLogic] = [
        BillParserLogicV1(),
        BillParserLogicV2()
    ]
    
    func parse(from url: URL) -> Bill? {
        guard let document = PDFDocument(url: url)?.string else {
            return nil
        }
        
        for logic in logics {
            if let bill = logic.parse(from: document) {
                return bill
            }
        }
        
        return nil
    }
}
