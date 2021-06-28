//
//  BarcodeScannerController.swift
//  TagMyPlant
//
//  Created by Dmytro Kostiuk on 26.06.21.
//

import Foundation

final class BarcodeScannerController: ObservableObject {
    
    @Published var barcodes: [Barcode] = []
    
    private var validator = BarcodeContentValidator()
    private var preprocessor = BarcodeContentPreprocessor()
    
    func storeBarcodeMetadata(type: String, content: String) {
        if type.lowercased().contains("qr") {
            barcodes.append(parseQrCodeContent(type: type, content: content))
        } else if type.lowercased().contains("code") {
            barcodes.append(parseBarcodeContent(type: type, content: content))
        } else {
            barcodes.append(parseUnknownTypeContent(type: type, content: content))
        }
    }
    
    func parseQrCodeContent(type: String, content: String) -> Barcode {
        switch content.components(separatedBy: ":")[0].lowercased() {
        case "http", "https":
            if validator.validateUrl(url: content) {
                return Barcode(type: type, data: BarcodeData.url(content))
            } else {
                return Barcode(type: type, data: BarcodeData.url(content), error: BarcodeError.invalidUrl)
            }
        case "mailto":
            let email = preprocessor.removeEmailPrefix(email: content)
            if validator.validateEmail(email: email) {
                return Barcode(type: type, data: BarcodeData.email(content))
            } else {
                return Barcode(type: type, data: BarcodeData.email(content), error: BarcodeError.invalidEmail)
            }
        case "tel":
            let phoneNumber = preprocessor.removePhoneNumberPrefix(phoneNumber: content)
            if validator.validatePhoneNumber(phoneNumber: phoneNumber) {
                return Barcode(type: type, data: BarcodeData.phoneNumber(content))
            } else {
                return Barcode(type: type, data: BarcodeData.phoneNumber(content), error: BarcodeError.invalidPhoneNumber)
            }
        default:
            return Barcode(type: type, data: BarcodeData.rawData(content))
        }
    }
    
    func parseBarcodeContent(type: String, content: String) -> Barcode {
        return Barcode(type: type, data: BarcodeData.linearCode(content))
    }
    
    func parseUnknownTypeContent(type: String, content: String) -> Barcode {
        return Barcode(type: type, data: BarcodeData.undefinedTypeData(content), error: BarcodeError.unknownBarcodeType)
    }
}

struct BarcodeContentPreprocessor {
    func removeEmailPrefix(email: String) -> String {
        return email.replacingOccurrences(of: "mailto:", with: "")
    }
    
    func removePhoneNumberPrefix(phoneNumber: String) -> String {
        return phoneNumber.replacingOccurrences(of: "tel:", with: "")
    }
}

struct BarcodeContentValidator {
    func validateUrl(url: String) -> Bool {
        let urlFormat = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let urlPredicate = NSPredicate(format: "SELF MATCHES %@", urlFormat)
        return urlPredicate.evaluate(with: url)
    }
    
    func validateEmail(email: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }
    
    func validatePhoneNumber(phoneNumber: String) -> Bool {
        let phoneFormat = #"^\(?\d{3}\)?[ -]?\d{3}[ -]?\d{4}$"#
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneFormat)
        return phonePredicate.evaluate(with: phoneNumber)
    }
}
