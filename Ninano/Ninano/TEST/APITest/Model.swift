//
//  ApiCaller.swift
//  Ninano
//
//  Created by Yoonjae on 2022/07/21.
//

import Foundation


// MARK: - APIResponse
struct APIResponse: Codable {
    let culturalEventInfo: CulturalEventInfo
}

// MARK: - CulturalEventInfo
struct CulturalEventInfo: Codable {
    let row: [Row]
}

// MARK: - Row
struct Row: Codable {
    let codename, guname, title, date: String
    let place, orgName, useTrgt, useFee: String
    let player, program, etcDesc: String
    let orgLink: String?
    let mainImg: String?
    let rgstdate, ticket, strtdate, endDate: String
    let themecode: String

    private enum CodingKeys: String, CodingKey {
        case codename = "CODENAME"
        case guname = "GUNAME"
        case title = "TITLE"
        case date = "DATE"
        case place = "PLACE"
        case orgName = "ORG_NAME"
        case useTrgt = "USE_TRGT"
        case useFee = "USE_FEE"
        case player = "PLAYER"
        case program = "PROGRAM"
        case etcDesc = "ETC_DESC"
        case orgLink = "ORG_LINK"
        case mainImg = "MAIN_IMG"
        case rgstdate = "RGSTDATE"
        case ticket = "TICKET"
        case strtdate = "STRTDATE"
        case endDate = "END_DATE"
        case themecode = "THEMECODE"
    }
}
