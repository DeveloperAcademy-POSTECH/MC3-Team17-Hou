//
//  ReserveModel.swift
//  Ninano
//
//  Created by KYUBO A. SHIM on 2022/07/25.
//

import UIKit

// MARK: model을 가져다 쓰는 VC 안에 private var viewModel = KeywordSubsModel() 을 하자.

struct ReservationSubsModel {
    var reserveItems: [ReservationSubs] {
        return ReservedCoreDataController.shared.reserveItemsList
    }
    
    func addReserveItems(nameCD: String, isReservedCD: Bool, dateReservedCD: Date?) {
        ReservedCoreDataController.shared.addReserveItems(nameCD: nameCD, isReservedCD: isReservedCD, dateReservedCD: dateReservedCD)
    }
    
    func removeReserveItem(nameCD: String?) {
        guard let nameCD = nameCD else { return }
        
        ReservedCoreDataController.shared.removeReserveItem(nameCD: nameCD)
    }
}
