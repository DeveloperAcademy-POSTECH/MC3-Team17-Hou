//
//  KeywordManager.swift
//  Ninano
//
//  Created by KYUBO A. SHIM on 2022/07/25.
//

import CoreData
import Foundation

class KeywordManager {
    static var shared = KeywordManager()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "NinanoModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    var keywordEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "KeywordList", in: context)
    }
    
    // MARK: - Create
    func insertKeyword(_ keyword: KeywordModel) {
        if let keywordEntity = keywordEntity {
            let managedObject = NSManagedObject(entity: keywordEntity, insertInto: context)
            managedObject.setValue(keyword.keywordSubs, forKey: "keywordSubs")
            saveToContext()
        }
    }
    
    // MARK: - Read
    func getKeyword() -> [KeywordModel] {
        var keywords: [KeywordModel] = []
        let fetchResults = fetchKeywordList()
        for result in fetchResults {
            let keywordData = KeywordModel(keywordSubs: result.keywordSubs ?? "")
            // 여기서 bool 이라서 "" false 없앰...
            keywords.append(keywordData)
        }
        return keywords
    }
    
    // MARK: - Delete an Item
    func deleteKeyword(with keyword: String) {
        let fetchResults = fetchKeywordList()
        let keywordData = fetchResults.filter({ $0.keywordSubs == keyword })[0]
        context.delete(keywordData)
        saveToContext()
    }
    
    // MARK: Delete all Item
    func deleteAll() {
        let fetchResults = fetchKeywordList()
        for result in fetchResults {
            context.delete(result)
        }
        saveToContext()
    }
  
    func fetchKeywordList() -> [KeywordList] {
        do {
            let request = KeywordList.fetchRequest()
            let results = try context.fetch(request)
            return results
        } catch {
            print(error.localizedDescription)
        }
        return []
    }
    
    private func saveToContext() {
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}
