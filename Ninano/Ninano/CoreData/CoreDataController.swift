//
//  CoreDataController.swift
//  Ninano
//
//  Created by KYUBO A. SHIM on 2022/07/24.
//

import Foundation
import CoreData

struct CoreDataController {
    static let shared = CoreDataController()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Subscription")
        container.loadPersistentStores { description, error in
            // if an error occurs, crash
            if let error = error {
                fatalError("Error: Unable to load the persistent stores. -> \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var eventItemsList: [Subscription] {
        do {
            return try persistentContainer.viewContext.fetch(NSFetchRequest<Subscription>(entityName: "Subscription"))
        } catch let error {
            print("Unable to retrieve list items \(error.localizedDescription)")
            return []
        }
    }
    
    // TODO: Date? 이게 문제가 되진 않을까??
    func addEventItems(nameCD: String, isLikedCD: Bool, isReservedCD: Bool, dateReservedCD: Date?) {
        let eventItem = NSEntityDescription.insertNewObject(forEntityName: "Subscription", into: persistentContainer.viewContext) as? Subscription
        
        eventItem?.setValue(nameCD, forKey: "nameCD")
        eventItem?.setValue(isLikedCD, forKey: "isLikedCD")
        eventItem?.setValue(isReservedCD, forKey: "isReservedCD")
        eventItem?.setValue(dateReservedCD, forKey: "dateReservedCD")
        
        save()
    }
    
    // TODO: NSPredicate 에서 filter 의 기능으로(?) name 만 받았다. 문제가 생기면 더 늘려보는 걸로 하자.
    func removeEventItem(nameCD: String) {
        let fetchRequest: NSFetchRequest<Subscription> = Subscription.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["nameCD", nameCD])
        
        do {
            guard let eventItem = try persistentContainer.viewContext.fetch(fetchRequest).first else { return }
            
            // delete
            persistentContainer.viewContext.delete(eventItem)
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
