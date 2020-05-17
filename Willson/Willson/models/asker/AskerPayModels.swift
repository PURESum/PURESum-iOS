//
//  AskerPayModels.swift
//  Willson
//
//  Created by JHKim on 2020/04/02.
//

import Foundation

// 고민결제
// GET /asker/payment/:concern_idx
// MARK: - AskerPay
struct AskerPay: Codable {
    let code, message: String
    let data: AskerPayData?
}

// MARK: - AskerPayData
struct AskerPayData: Codable {
    let willsoners: [AskerPayWillsoner]
    let tickets: [Ticket]
    let concern: AskerPayConcern
}

// MARK: - AskerPayConcern
struct AskerPayConcern: Codable {
    let content, wilGender: String
    let subcategoryIdx, askerIdx: Int
    let asker: NicknameData
    let subcategory: Subcategory
    let personalities: [NameData]
    let direction: NameData

    enum CodingKeys: String, CodingKey {
        case content
        case wilGender = "wil_gender"
        case subcategoryIdx = "subcategory_idx"
        case askerIdx = "asker_idx"
        case asker, subcategory, personalities, direction
    }
}

// MARK: - Subcategory
struct Subcategory: Codable {
    let idx: Int
    let name: String
    let categoryIdx: Int
    let category: NameData

    enum CodingKeys: String, CodingKey {
        case idx, name
        case categoryIdx = "category_idx"
        case category
    }
}

// MARK: - Ticket
struct Ticket: Codable {
    let type, amount: String
    let idx: Int
}

// MARK: - AskerPayWillsoner
struct AskerPayWillsoner: Codable {
    let avgRating: String
    let idx: Int
    let experience, introduction: String
    let asker: Asker
    let subcategories, keywords: [NameData]
    let image: ImageData

    enum CodingKeys: String, CodingKey {
        case avgRating = "avg_rating"
        case idx, experience, introduction, asker, subcategories, keywords, image
    }
}

// 고민 결제 3
// POST /asker/payment/purchase
// MARK: - AskerPay3
struct AskerPay3: Codable {
    let code, message: String
    let data: AskerPay3Data
}

// MARK: - AskerPay3Data
struct AskerPay3Data: Codable {
    let asker: AskerPoint
    let notEnought: Int
    let tickets: [TicketData]

    enum CodingKeys: String, CodingKey {
        case asker
        case notEnought = "not_enought"
        case tickets
    }
}

// MARK: - AskerPoint
struct AskerPoint: Codable {
    let point: PointHoneypot
}

// MARK: - PointHoneypot
struct PointHoneypot: Codable {
    let honeypot: String
}

// MARK: - Ticket
struct TicketData: Codable {
    let amount, price: String
}

// 최종결제
// POST /asker/payment/:concern_idx
// MARK: - AskerPayComplete
struct AskerPayComplete: Codable {
    let createdAt, updatedAt, idx: Int?
    let content, wilGender, type, time, status: String?
    let askerIdx, subcategoryIdx, directionIdx, timer: Int?
    let code, message: String?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case idx, content
        case wilGender = "wil_gender"
        case type, time, status
        case askerIdx = "asker_idx"
        case subcategoryIdx = "subcategory_idx"
        case directionIdx = "direction_idx"
        case timer, code, message
    }
}
