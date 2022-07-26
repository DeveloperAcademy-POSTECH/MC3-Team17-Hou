//
//  ReserveManager.swift
//  Ninano
//
//  Created by KYUBO A. SHIM on 2022/07/25.
//

import CoreData
import Foundation

class ReserveManager {
    static var shared = ReserveManager()
    
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
    
    var reserveEntity: NSEntityDescription? {
        return NSEntityDescription.entity(forEntityName: "ReserveList", in: context)
    }
    
    // MARK: - Create
    func insertReserve(_ reserve: ReserveModel) {
        if let reserveEntity = reserveEntity {
            let managedObject = NSManagedObject(entity: reserveEntity, insertInto: context)
            managedObject.setValue(reserve.isReserved, forKey: "isReserved")
            managedObject.setValue(reserve.reserveDate, forKey: "reserveDate")
            managedObject.setValue(reserve.url, forKey: "url")
            saveToContext()
        }
    }
    
    // MARK: - Read
    func getReserve() -> [ReserveModel] {
        var reserves: [ReserveModel] = []
        let fetchResults = fetchReserveList()
        for result in fetchResults {
            let reserveData = ReserveModel(reserveDate: result.reserveDate ?? Date(), isReserved: result.isReserved, url: result.url ?? "")
            // 여기서 bool 이라서 "" false 없앰...
            reserves.append(reserveData)
        }
        return reserves
    }
    
    // MARK: - Update
//    func updateReserve(_ reserve: ReserveModel) {
//        let fetchResults = fetchReserveList()
//        for result in fetchResults {
//            if result.url == reserve.url {
//                result.isReserved.toggle()
//                // TODO: 이게 == 이 아니라 .toggle() 이어도 되는가?
//            }
//        }
//        saveToContext()
//    }
    
    // MARK: - Delete an Item
    func deleteReserve(with url: String) {
        let fetchResults = fetchReserveList()
        let reserveData = fetchResults.filter({ $0.url == url })[0]
        context.delete(reserveData)
        saveToContext()
    }
    
    // MARK: Delete all Item
    func deleteAll() {
        let fetchResults = fetchReserveList()
        for result in fetchResults {
            context.delete(result)
        }
        saveToContext()
    }
  
    func fetchReserveList() -> [ReserveList] {
        do {
            let request = ReserveList.fetchRequest()
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
