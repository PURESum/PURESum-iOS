//
//  AskerMain.swift
//  Willson
//
//  Created by JHKim on 2020/03/24.
//

import Foundation

// 질문자 메인
// GET /asker/main
// MARK: - AskerMain
struct AskerMain: Codable {
    let landings: [Landing]
    let subcategories: [IdxData]
    let reviews: Reviews
    let interviews: [Interview]
    let stories: [Story]
}

// MARK: - Interview
struct Interview: Codable {
    let idx: Int
    let title: String
    let image: String?
    let date: String
    let category: NameData
}

// MARK: - Landing
struct Landing: Codable {
    let copy: String
    let pic: String
    let btn: String
}

// MARK: - Reviews
struct Reviews: Codable {
    let count: Int
    let rows: [Row]?
}

// MARK: - Row
struct Row: Codable {
    let title, content: String
    let rating: Float
    let date: String // 형식 
}

// MARK: - Story
struct Story: Codable {
    let idx: Int
    let title, author: String
    let image: String?
    let date: String
    let likeCnt: Int
    let likes: Bool

    enum CodingKeys: String, CodingKey {
        case idx, title, author, image, date
        case likeCnt = "like_cnt"
        case likes
    }
}

// 질문자 추천 윌스너들
// sker/main/willsoners/:subcategory_idx
// MARK: - AskerMainWillsoner
struct AskerMainWillsoner: Codable {
    let code, message: String
    let data: [AskerMainWillsonerData]
}

// MARK: - AskerMainWillsonerData
struct AskerMainWillsonerData: Codable {
    let avgRating: String
    let idx: Int
    let experience: String
    let asker: Asker
    let subcategories: [NameData]
    let image: ChatRoomImage?
    let keywords: [NameData]

    enum CodingKeys: String, CodingKey {
        case avgRating = "avg_rating"
        case idx, experience, asker, subcategories, image, keywords
    }
}
