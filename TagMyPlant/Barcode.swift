//
//  Barcode.swift
//  TagMyPlant
//
//  Created by Dmytro Kostiuk on 26.06.21.
//

import Foundation

struct Barcode: Identifiable {
    var id = UUID()
    var type: String
    var data: BarcodeData
    var error: BarcodeError?
}

enum BarcodeData {
    case url(String)
    case email(String)
    case phoneNumber(String)
    case rawData(String)
    case linearCode(String)
    case undefinedTypeData(String)
    
    func getContent() -> String {
        switch self {
        case .url(let url):
            return url
        case .email(let email):
            return email
        case .phoneNumber(let phoneNumber):
            return phoneNumber
        case .rawData(let rawData):
            return rawData
        case .linearCode(let linearCode):
            return linearCode
        case .undefinedTypeData(let undefinedTypeData):
            return undefinedTypeData
        }
    }
    
    func getUrlDescription() -> String? {
        switch self {
        case .url:
            return "Open the URL"
        case .email:
            return "Open the Email"
        case .phoneNumber:
            return "Call the number"
        case .rawData, .linearCode, .undefinedTypeData:
            return nil
        }
    }
    
    func getImageName() -> String {
        switch self {
        case .url:
            return "link"
        case .email:
            return "envelope"
        case .phoneNumber:
            return "phone"
        case .rawData:
            return "doc.text"
        case .linearCode:
            return "doc.text"
        case .undefinedTypeData:
            return "doc.text"
        }
    }
}

enum BarcodeError: String {
    case invalidUrl = "BarcodeDataError: Invalid URL"
    case invalidEmail = "BarcodeDataError: Invalid Email"
    case invalidPhoneNumber = "BarcodeDataError: Invalid PhoneNumber"
    case unknownBarcodeType = "BarcodeTypeError: Unknown BarcodeType"
}
