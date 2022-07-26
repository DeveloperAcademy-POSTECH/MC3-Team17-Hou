//
//  LikeManager.swift
//  Ninano
//
//  Created by KYUBO A. SHIM on 2022/07/25.
//

import CoreData
import Foundation

class LikeManager {
    static var shared = LikeManager()
    
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
    
    var likeEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "LikeList", in: context)
    }
    
    // MARK: - Create
    func insertLike(_ like: LikeModel) {
        if let likeEntity = likeEntity {
            let managedObject = NSManagedObject(entity: likeEntity, insertInto: context)
            managedObject.setValue(like.isLiked, forKey: "isLiked")
            managedObject.setValue(like.nameLike, forKey: "nameLike")
            managedObject.setValue(like.url, forKey: "url")
            saveToContext()
        }
    }
    
    // MARK: - Read
    func getLike() -> [LikeModel] {
        var likes: [LikeModel] = []
        let fetchResults = fetchLikeList()
        for result in fetchResults {
            let likeData = LikeModel(nameLike: result.nameLike ?? "", isLiked: result.isLiked, url: result.url ?? "" )
            // 여기서 bool 이라서 "" false 없앰...
            likes.append(likeData)
        }
        return likes
    }
    
    // MARK: - Update
    func updateLike(_ like: LikeModel) {
        let fetchResults = fetchLikeList()
        for result in fetchResults where result.url == like.url {
                result.isLiked.toggle()
                // TODO: 이게 == 이 아니라 .toggle() 이어도 되는가?
        }
        saveToContext()
    }
    
    // MARK: - Delete an Item
    func deleteLike(with url: String) {
        let fetchResults = fetchLikeList()
        let likeData = fetchResults.filter({ $0.url == url })[0]
        context.delete(likeData)
        saveToContext()
    }
    
    // MARK: Delete all Item
    func deleteAll() {
        let fetchResults = fetchLikeList()
        for result in fetchResults {
            context.delete(result)
        }
        saveToContext()
    }
  
    func fetchLikeList() -> [LikeList] {
        do {
            let request = LikeList.fetchRequest()
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
