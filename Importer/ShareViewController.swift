//
//  ShareViewController.swift
//  Importer
//
//  Created by Artem Belkov on 28.02.2021.
//

import UIKit
import Social

class ShareViewController: UIViewController {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    private let pdfType = "com.adobe.pdf"
    private let billsKey = "bills"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 12
        activityIndicator.startAnimating()
        
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        for attachment in attachments where attachment.hasItemConformingToTypeIdentifier(pdfType) {
            attachment.loadItem(forTypeIdentifier: pdfType, options: nil) { data, error in
                if let url = data as? URL,
                   let bill = BillParser.default.parse(from: url) {
                    
                    do {
                        var bills = (try? UserDefaults.default.getObject(forKey: self.billsKey, castTo: [Bill].self)) ?? []
                        bills.append(bill)
                        try UserDefaults.default.setObject(bills, forKey: self.billsKey)
                        
                        print("Successefully saving bill")
                        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)

                        DispatchQueue.main.async {
                            self.activityIndicator.stopAnimating()
                        }
                        
                    } catch {
                        fatalError("Error to saving bill")
                    }
                    
                } else {
                    fatalError("Error to parsing bill")
                }
            }
        }
    }
}
