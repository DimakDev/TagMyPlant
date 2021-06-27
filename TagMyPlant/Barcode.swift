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
    var content: [BarcodeContent]
}

enum BarcodeContent {
    case url(String)
    case email(String)
    case phoneNumber(String)
    case date(String)
    case text(String)
    
    func getType() -> String {
        switch self {
        case .url:
            return "URL"
        case .email:
            return "Email"
        case .phoneNumber:
            return "Phone number"
        case .date:
            return "Date"
        case .text:
            return "Text"
        }
    }
    
    func getValue() -> String {
        switch self {
        case .url(let url):
            return url
        case .email(let email):
            return email
        case .phoneNumber(let number):
            return number
        case .date(let date):
            return date
        case .text(let text):
            return text
        }
    }
}
