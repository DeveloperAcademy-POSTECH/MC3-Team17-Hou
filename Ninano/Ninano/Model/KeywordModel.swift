//
//  KeywordModel.swift
//  Ninano
//
//  Created by KYUBO A. SHIM on 2022/07/24.
//
//
import UIKit

// MARK: model을 가져다 쓰는 VC 안에 private var viewModel = KeywordSubsModel() 을 하자.

struct KeywordSubsModel {
    var keywordItems: [KeywordSubs] {
        return KeywordCoreDataController.shared.keywordItemsList
    }
    
    func addKeywordItems(keywordCD: String) {
        KeywordCoreDataController.shared.addKeywordItems(keywordCD: keywordCD)
    }
    
    func removeKeywordItem(keywordCD: String?) {
        guard let keywordCD = keywordCD else { return }
        
        KeywordCoreDataController.shared.removeKeywordItem(keywordCD: keywordCD)
    }
}
