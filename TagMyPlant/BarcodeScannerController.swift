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
    
    func storeBarcodeMetadata(barcodeType: String, barcodeContent: String) {
        var barcode: Barcode
        
        if barcodeType.lowercased().contains("qr") {
            barcode = parseQrCodeContent(barcodeType: barcodeType, barcodeContent: barcodeContent)
        } else if barcodeType.lowercased().contains("code") {
            barcode = parseBarcodeContent(barcodeType: barcodeType, barcodeContent: barcodeContent)
        } else {
            barcode = parseIvalidBarcodeTypeContent(barcodeType: barcodeType, barcodeContent: barcodeContent)
        }
        
        barcodes.append(barcode)
    }
    
    func parseQrCodeContent(barcodeType: String, barcodeContent: String) -> Barcode {
        var barcode: Barcode
        
        switch barcodeContent.components(separatedBy: ":")[0].lowercased() {
        case "http", "https":
            if validator.validateUrl(urlString: barcodeContent) {
                barcode = Barcode(type: barcodeType, data: BarcodeData.url(barcodeContent))
            } else {
                barcode = Barcode(type: barcodeType, data: BarcodeData.url(barcodeContent), error: BarcodeError.invalidUrl)
            }
        case "mailto":
            let email = preprocessor.processEmailString(emailString: barcodeContent)
            if validator.validateEmail(emailString: email) {
                barcode = Barcode(type: barcodeType, data: BarcodeData.email(barcodeContent))
            } else {
                barcode = Barcode(type: barcodeType, data: BarcodeData.email(barcodeContent), error: BarcodeError.invalidEmail)
            }
        case "tel":
            let phoneNumber = preprocessor.processPhoneNumberString(phoneNumberString: barcodeContent)
            if validator.validatePhoneNumber(phoneNumberString: phoneNumber) {
                barcode = Barcode(type: barcodeType, data: BarcodeData.phoneNumber(barcodeContent))
            } else {
                barcode = Barcode(type: barcodeType, data: BarcodeData.phoneNumber(barcodeContent), error: BarcodeError.invalidPhoneNumber)
            }
        default:
            barcode = Barcode(type: barcodeType, data: BarcodeData.rawData(barcodeContent))
        }
        
        return barcode
    }
    
    func parseBarcodeContent(barcodeType: String, barcodeContent: String) -> Barcode {
        return Barcode(type: barcodeType, data: BarcodeData.linearCode(barcodeContent))
    }
    
    func parseIvalidBarcodeTypeContent(barcodeType: String, barcodeContent: String) -> Barcode {
        return Barcode(type: barcodeType, data: BarcodeData.undefinedTypeData(barcodeContent), error: BarcodeError.undefinedBarcodeType)
    }
}

struct BarcodeContentPreprocessor {
    func processEmailString(emailString: String) -> String {
        let email = emailString.replacingOccurrences(of: "mailto:", with: "")
        return email
    }
    
    func processPhoneNumberString(phoneNumberString: String) -> String {
        let phoneNumber = phoneNumberString.replacingOccurrences(of: "tel:", with: "")
        let phoneNumberFiltered = phoneNumber.replacingOccurrences(of: "[() -]",
                                                                   with: "",
                                                                   options: .regularExpression)
        return phoneNumberFiltered
    }
}

struct BarcodeContentValidator {
    func validateUrl(urlString: String) -> Bool {
        let urlFormat = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let urlPredicate = NSPredicate(format: "SELF MATCHES %@", urlFormat)
        return urlPredicate.evaluate(with: urlString)
    }
    
    func validateEmail(emailString: String) -> Bool {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: emailString)
    }
    
    func validatePhoneNumber(phoneNumberString: String) -> Bool {
        let phoneFormat = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phonePredicate = NSPredicate(format: "SELF MATCHES %@", phoneFormat)
        return phonePredicate.evaluate(with: phoneNumberString)
    }
}
