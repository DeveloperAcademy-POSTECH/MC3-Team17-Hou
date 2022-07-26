//
//  SubscriptionModel.swift
//  Ninano
//
//  Created by KYUBO A. SHIM on 2022/07/25.
//

import UIKit

// TODO: table 이나 이런게 있으면 ⭐️해당 뷰에... reloadData() 해야 한다. 안 그러면 오류가 난다.
/// Like
struct LikeDataModel {
    var likeItems: [LikeList] {
        return LikeManager.shared.fetchLikeList()
    }
    
    func addLikeItems(url: String, isLiked: Bool, name: String) {
        LikeManager.shared.insertLike(LikeModel(nameLike: name, isLiked: isLiked, url: url))
    }
    
    // remove 를 하기 위해 내부 manager 수정... 해보기 7/26 오후 3시49분에 작업들어감
    func removeLikeItems(url: String?) {
        guard let url = url else { return }
        LikeManager.shared.deleteLike(with: url)
    }
    
    /// TODO: keyword 에서만 사용할 예정이지만 Test 에서 사용해보려 추가함
    func removeAllLikeItems() {
        LikeManager.shared.deleteAll()
    }
}

// TODO: table 이나 이런게 있으면 ⭐️해당 뷰에... reloadData() 해야 한다. 안 그러면 오류가 난다.
/// Reserve
struct ReserveDataModel {
    var reserveItems: [ReserveList] {
        return ReserveManager.shared.fetchReserveList()
    }
    
    func addReserveItems(url: String, isReserved: Bool, reserveDate: Date?) {
        ReserveManager.shared.insertReserve(ReserveModel(reserveDate: reserveDate, isReserved: isReserved, url: url))
    }
    
    func removeReserveItems(url: String?) {
        guard let url = url else { return }
        ReserveManager.shared.deleteReserve(with: url)
    }
    
    /// TODO: keyword 에서만 사용할 예정이지만 Test 에서 사용해보려 추가함
    func removeAllReservedItems() {
        ReserveManager.shared.deleteAll()
    }
}

// TODO: table 이나 이런게 있으면 ⭐️해당 뷰에... reloadData() 해야 한다. 안 그러면 오류가 난다.
/// Keyword
struct KeywordDataModel {
    var keywordItems: [KeywordList] {
        return KeywordManager.shared.fetchKeywordList()
    }
    
    func addKeywordItems(keyword: String) {
        KeywordManager.shared.insertKeyword(KeywordModel(keywordSubs: keyword))
    }
    
    func removeKeywordItems(keyword: String?) {
        guard let keywords = keyword else { return }
        KeywordManager.shared.deleteKeyword(with: keywords)
    }
    
    func removeAllKeywordItems() {
        KeywordManager.shared.deleteAll()
    }
    
}

struct LikeModel: Codable, Equatable {
    let nameLike: String
    let isLiked: Bool
    let url: String
}

struct ReserveModel: Codable, Equatable {
    let reserveDate: Date?
    let isReserved: Bool
    let url: String
}

struct KeywordModel: Codable, Equatable {
    let keywordSubs: String
}
