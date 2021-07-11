//
//  BarcodeViewModel.swift
//  TagMyPlant
//
//  Created by Dmytro Kostiuk on 29.06.21.
//

import CoreData

struct BarcodeViewModel {
    let barcode: Barcode
    
    var id: NSManagedObjectID {
        return barcode.objectID
    }
    
    var createdAt: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm E, d MMM"
        
        if let createdAt = barcode.createdAt {
            return formatter.string(from: createdAt)
        } else {
            return ""
        }
    }
    
    var type: String {
        return barcode.type ?? ""
    }
    
    var content: String {
        return barcode.content ?? ""
    }
    
    var contentIcon: String {
        return barcode.contentIcon ?? ""
    }
    
    var urlDescription: String {
        return barcode.urlDescription ?? ""
    }
    
    var url: URL? {
        return URL(string: barcode.url ?? "")
    }
}
