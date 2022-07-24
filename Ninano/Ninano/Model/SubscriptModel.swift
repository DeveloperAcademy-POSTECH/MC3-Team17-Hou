//
//  SubscriptModel.swift
//  Ninano
//
//  Created by KYUBO A. SHIM on 2022/07/24.
//

import UIKit

// MARK: model을 가져다 쓰는 VC 안에 private var viewModel = SubscriptModel() 을 하자.

struct SubscriptModel {
    var eventItems: [Subscription] {
        return CoreDataController.shared.eventItemsList
    }
    
    func addEventItems(nameCD: String, isLikedCD: Bool) {
        CoreDataController.shared.addEventItems(nameCD: nameCD, isLikedCD: isLikedCD)
    }
    
    func removeEventItem(nameCD: String?) {
        guard let nameCD = nameCD else { return }
        
        CoreDataController.shared.removeEventItem(nameCD: nameCD)
    }
}
