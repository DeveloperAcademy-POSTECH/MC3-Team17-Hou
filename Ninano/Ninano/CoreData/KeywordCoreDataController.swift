//
//  KeywordCoreDataController.swift
//  Ninano
//
//  Created by KYUBO A. SHIM on 2022/07/24.
//

import Foundation
import CoreData

struct KeywordCoreDataController {
    static let shared = KeywordCoreDataController()
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "KeywordSubs")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Error: Unable to load the persistent stores. -> \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    var keywordItemsList: [KeywordSubs] {
        do {
            return try persistentContainer.viewContext.fetch(NSFetchRequest<KeywordSubs>(entityName: "KeywordSubs"))
        } catch let error {
            print("Unable to retrieve list items \(error.localizedDescription)")
            return []
        }
    }
    
    func addKeywordItems(keywordCD: String) {
        let keywordItem = NSEntityDescription.insertNewObject(forEntityName: "KeywordSubs", into: persistentContainer.viewContext) as? KeywordSubs
        
        keywordItem?.setValue(keywordCD, forKey: "keywordCD")
        
        save()
    }
    
    func removeKeywordItem(keywordCD: String) {
        let fetchRequest: NSFetchRequest<KeywordSubs> = KeywordSubs.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "%K == %@", argumentArray: ["keywordCD", keywordCD])
        
        do {
            guard let keywordItem = try persistentContainer.viewContext.fetch(fetchRequest).first else { return }
            
            // delete
            persistentContainer.viewContext.delete(keywordItem)
            save()
        } catch let error {
            print("Unable to delete event Item with name \(keywordCD). Error: \(error.localizedDescription)")
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
