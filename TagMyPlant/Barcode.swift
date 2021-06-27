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

enum BarcodeError: String {
    case invalidUrl = "BarcodeDataError: Invalid URL"
    case invalidEmail = "BarcodeDataError: Invalid Email"
    case invalidPhoneNumber = "BarcodeDataError: Invalid PhoneNumber"
    case unknownBarcodeType = "BarcodeTypeError: Unknown BarcodeType"
}
