//
//  CoreDataManager.swift
//  TagMyPlant
//
//  Created by Dmytro Kostiuk on 29.06.21.
//

import Foundation
import CoreData

enum StorageType {
    case inMemory, persistent
}

class CoreDataManager {
    let persistentContainer: NSPersistentContainer
    
    static let shared = CoreDataManager(storageType: .persistent)

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
    
    private init(storageType: StorageType) {
        persistentContainer = NSPersistentContainer(name: "BarcodeModel")
        
        if storageType == .inMemory {
          let description = NSPersistentStoreDescription()
          description.url = URL(fileURLWithPath: "/dev/null")
          self.persistentContainer.persistentStoreDescriptions = [description]
        }
        
        persistentContainer.loadPersistentStores{ (description, error) in
            if let error = error {
                fatalError("Unable to initialize Core Data Stack \(error)")
            }
        }
    }
}
