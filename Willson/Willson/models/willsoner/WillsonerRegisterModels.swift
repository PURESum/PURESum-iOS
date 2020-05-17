//
//  WillsonerRegisterModels.swift
//  Willson
//
//  Created by JHKim on 2020/03/04.
//

import Foundation

// 윌스너 해시태그
// POST /willsoner/register/keyword
// MARK: - HashTag
struct HashTag: Codable {
    let code, message: String
    let data: [HashTagData]?
}

// MARK: - HashTagData
struct HashTagData: Codable {
    let createdAt, updatedAt, approved, categoryIdx: Int?
    let name: String
    let idx: Int

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case idx, name, approved
        case categoryIdx = "category_idx"
    }
}

// 윌스너 신청 - 이미지
// GET /willsoner/register/image

// MARK: - Image
struct Image: Codable {
    let code, message: String
    let data: [ImageData]
}

// MARK: - ImageData
struct ImageData: Codable {
    let idx: Int?
    let name, detail: String?
    let pic: String
}

// 핸드폰 인증번호 요청
// POST /willsoner/register/phone/verify

// 핸드폰 인증번호 확인
// POST /willsoner/register/phone/check

// MARK: - PhoneVerify
struct PhoneVerify: Codable {
    let code, message: String
    let data: String?
}

// 윌스너 등록 완료
// POST /willsoner/register/complete

// MARK: - RegisterComplete
struct RegisterComplete: Codable {
    let code, message: String
    let data: RegisterCompleteData?
}

// MARK: - DataClass
struct RegisterCompleteData: Codable {
    let loginAt, createdAt, updatedAt: Int
    let idx, askerIdx: Int
    let status: String?
    let experience, introduction: String
    let imageIdx: Int

    enum CodingKeys: String, CodingKey {
        case loginAt = "login_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case idx, status
        case askerIdx = "asker_idx"
        case experience, introduction
        case imageIdx = "image_idx"
    }
}
