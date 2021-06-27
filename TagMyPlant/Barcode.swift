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
    
    func get() -> String {
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
}

enum BarcodeError {
    case invalidUrl
    case invalidEmail
    case invalidPhoneNumber
    case undefinedBarcodeType
    
    func get() -> String {
        switch self {
        case .invalidUrl:
            return "BarcodeDataError: Invalid URL"
        case .invalidEmail:
            return "BarcodeDataError: Invalid Email"
        case .invalidPhoneNumber:
            return "BarcodeDataError: Invalid PhoneNumber"
        case .undefinedBarcodeType:
            return "BarcodeTypeError: Undefined BarcodeType"
        }
    }
}
