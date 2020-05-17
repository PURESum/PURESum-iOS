//
//  AskerRequestModels.swift
//  Willson
//
//  Created by JHKim on 2020/03/04.
//

import Foundation

// 고민신청 - 세부 카테고리
// POST asker/request/subcategory

// 윌스너 신청 - 세부 카테고리
// POST willsoner/register/subcategory

// 고민신청 - 감정
// GET asker/request/feeling

// 고민신청 - 헬퍼 성격
// GET asker/request/willsoner_type

// 고민 신청 - 대화 방향
// GET asker/request/direction

// MARK: - BasicModel
struct BasicModel: Codable {
    let code, message: String
    let data: [IdxData]?
}

// MARK: - IdxData
struct IdxData: Codable {
    let idx: Int
    let name: String
}

// 고민신청 완료
// POST /asker/request/complete

// MARK: - RequestComplete
struct RequestComplete: Codable {
    let code, message: String
    let data: RequestCompleteData?
}

// MARK: - DataClass
struct RequestCompleteData: Codable {
    let createdAt, updatedAt, idx, askerIdx: Int
    let subcategoryIdx: Int
    let content, wilGender: String
    let directionIdx: Int
    let type, time: String

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case idx
        case askerIdx = "asker_idx"
        case subcategoryIdx = "subcategory_idx"
        case content
        case wilGender = "wil_gender"
        case directionIdx = "direction_idx"
        case type
        case time
    }
}

