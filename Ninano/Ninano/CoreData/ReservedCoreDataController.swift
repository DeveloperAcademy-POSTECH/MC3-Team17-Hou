//
//  ReservedCoreDataController.swift
//  Ninano
//
//  Created by KYUBO A. SHIM on 2022/07/25.
//

import Foundation
import CoreData

struct ReservedCoreDataController {
    static let shared = ReservedCoreDataController()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NinanoCoreData")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: Unable to load the persistent stores. -> \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var reserveItemsList: [ReservationSubs] {
        do {
            return try persistentContainer.viewContext.fetch(NSFetchRequest<ReservationSubs>(entityName: "ReservationSubs"))
        } catch let error {
            print("Unable to retrieve list items \(error.localizedDescription)")
            return []
        }
    }
    
    func addReserveItems(nameCD: String, isReservedCD: Bool, dateReservedCD: Date?) {
        let reserveItem = NSEntityDescription.insertNewObject(forEntityName: "ReservationSubs", into: persistentContainer.viewContext) as? ReservationSubs
        
        reserveItem?.setValue(nameCD, forKey: "nameCD")
        reserveItem?.setValue(isReservedCD, forKey: "isReservedCD")
        reserveItem?.setValue(dateReservedCD, forKey: "dateReservedCD")
        
        save()
    }
    
    func removeReserveItem(nameCD: String) {
        let fetchRequest: NSFetchRequest<ReservationSubs> = ReservationSubs.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["nameCD", nameCD])
        
        do {
            guard let reserveItem = try persistentContainer.viewContext.fetch(fetchRequest).first else { return }
            
            // delete
            persistentContainer.viewContext.delete(reserveItem)
            save()
        } catch let error {
            print("Unable to delete event Item with name \(nameCD). Error: \(error.localizedDescription)")
        }
    }
    
    private func save() {
        do {
            try persistentContainer.viewContext.save()
        } catch let error {
            print("Unable to save. Error: \(error.localizedDescription)")
        }
    }
}
