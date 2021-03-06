//
//  BarcodeViewModel.swift
//  TagMyPlant
//
//  Created by Dmytro Kostiuk on 29.06.21.
//

import Foundation
import CoreData

class ContentViewModel: ObservableObject {
    var barcodeType: String = ""
    var barcodeContent: String = ""
    
    @Published var barcodes: [BarcodeViewModel] = []
    
    func getAllBarcodes() {
        barcodes = CoreDataManager.shared.getAllBarcodes().map(BarcodeViewModel.init)
    }
    
    func deleteBarcode(_ barcode: BarcodeViewModel) {
        if let existingTask = CoreDataManager.shared.getBarcodeById(id: barcode.id) {
            CoreDataManager.shared.deleteBarcode(barcode: existingTask)
        }
    }
    
    func saveBarcode() {
        let barcode = Barcode(context: CoreDataManager.shared.viewContext)
        parseBarcodeMetadata(barcode: barcode)
        CoreDataManager.shared.save()
    }
}

extension ContentViewModel {
    private func parseBarcodeMetadata(barcode: Barcode) {
        let components = barcodeContent.components(separatedBy: ":")
        
        if let prefix = components.first {
            switch prefix {
            case "http", "https":
                barcode.createdAt = Date()
                barcode.type = barcodeType
                barcode.content = barcodeContent
                barcode.contentIcon = "link"
                if validateUrl(url: barcodeContent.lowercased()) {
                    barcode.url = barcodeContent
                    barcode.urlDescription = "Open the link"
                }
            case "mailto":
                barcode.createdAt = Date()
                barcode.type = barcodeType
                barcode.content = barcodeContent
                barcode.contentIcon = "envelope"
                if validateEmail(email: components[1]) {
                    barcode.url = barcodeContent
                    barcode.urlDescription = "Open the Email"
                }
            case "tel":
                barcode.createdAt = Date()
                barcode.type = barcodeType
                barcode.content = barcodeContent
                barcode.contentIcon = "phone"
                if validatePhoneNumber(phoneNumber: components[1]) {
                    barcode.url = barcodeContent
                    barcode.urlDescription = "Call the number"
                }
            default:
                barcode.createdAt = Date()
                barcode.type = barcodeType
                barcode.content = barcodeContent
                barcode.contentIcon = "doc.text"
            }
        } else {
            barcode.createdAt = Date()
            barcode.type = barcodeType
            barcode.content = barcodeContent
            barcode.contentIcon = "doc.text"
        }
    }
    
    private func validateUrl(url: String) -> Bool {
        let urlFormat = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let urlPredicate = NSPredicate(format: "SELF MATCHES %@", urlFormat)
        return urlPredicate.evaluate(with: url)
    }
    
    private func validateEmail(email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    private func validatePhoneNumber(phoneNumber: String) -> Bool {
        // matches (123) 456-7890 | 123-456-7890
        let phoneFormat = #"((\(\d{3}\) ?)|(\d{3}-))?\d{3}-\d{4}"#
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneFormat)
        return phonePredicate.evaluate(with: phoneNumber)
    }
}
