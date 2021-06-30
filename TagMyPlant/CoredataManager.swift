//
//  CoredataManager.swift
//  TagMyPlant
//
//  Created by Dmytro Kostiuk on 29.06.21.
//

import Foundation
import CoreData

class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    static let shared = CoreDataManager()
    
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    func getBarcodeById(id: NSManagedObjectID) -> Barcode? {
        do {
            return try viewContext.existingObject(with: id) as? Barcode
        } catch {
            return nil
        }
    }
    
    func getAllBarcodes() -> [Barcode] {
        let request: NSFetchRequest<Barcode> = Barcode.fetchRequest()
        
        do {
            return try viewContext.fetch(request)
        } catch {
            return []
        }
    }
    
    func deleteBarcode(barcode: Barcode) {
        viewContext.delete(barcode)
        save()
    }
    
    func save() {
        do {
            try viewContext.save()
        } catch {
            viewContext.rollback()
            print(error.localizedDescription)
        }
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "BarcodeModel")
        persistentContainer.loadPersistentStores{ (description, error) in
            if let error = error {
                fatalError("Unable to initialize Core Data Stack \(error)")
            }
        }
    }
}
