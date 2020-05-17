//
//  WillsonerMypageModels.swift
//  Willson
//
//  Created by JHKim on 2020/03/04.
//

import Foundation

// 마이페이지 (윌스너)
// /willsoner/mypage/home

// MARK: - WillsonerMypageHome
struct WillsonerMypageHome: Codable {
    let code, message: String
    let data: WillsonerMypageHomeData
}

// MARK: - WillsonerMypageHomeData
struct WillsonerMypageHomeData: Codable {
    let nickname, email: String
    let willsoner: WillsonerMypageHomeWillsoner?
    let point: Point?
    let auth: Int?
}

// MARK: - WillsonerMypageHomeWillsoner
struct WillsonerMypageHomeWillsoner: Codable {
    let avgRating: String?
    let introduction: String
    let image: ChatRoomImage
    let keywords: [NameData]
    
    enum CodingKeys: String, CodingKey {
        case avgRating = "avg_rating"
        case introduction,image, keywords
    }
}

// MARK: - Point
struct Point: Codable {
    let honeypot: String?
}

