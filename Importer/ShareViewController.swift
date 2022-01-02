//
//  ShareViewController.swift
//  Importer
//
//  Created by Artem Belkov on 28.02.2021.
//

import UIKit
import Social

final class ShareViewController: UIViewController {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    private let billParser: IBillParser = BillParser()
    private let billStore: IBillStore = BillStore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 12
        activityIndicator.startAnimating()
        
        let attachments = (self.extensionContext?.inputItems.first as? NSExtensionItem)?.attachments ?? []
        for attachment in attachments where attachment.hasItemConformingToTypeIdentifier(.pdfType) {
            attachment.loadItem(forTypeIdentifier: .pdfType, options: nil) { [weak self] data, error in
                if let url = data as? URL,
                   let bill = self?.billParser.parse(from: url) {
                    self?.billStore.saveBill(bill)
                    
                    DispatchQueue.main.async {
                        self?.activityIndicator.stopAnimating()
                    }
                } else {
                    fatalError("Error to parsing bill")
                }
            }
        }
    }
}

private extension String {
    static let pdfType = "com.adobe.pdf"
}
