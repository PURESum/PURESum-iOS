//
//  AskerConcernModels.swift
//  Willson
//
//  Created by JHKim on 2020/03/04.
//

import Foundation

// 고민 신청(질문자) - 고민 목록
// GET asker/list/concerns

// MARK: - Concern
struct Concern: Codable {
    let code, message: String
    let data: Concerns?
}

// MARK: - Concerns
struct Concerns: Codable {
    let totalCount: Int
    let realtime, reserve, completed: ConcernData?
    
    enum CodingKeys: String, CodingKey {
        case realtime, reserve, completed
        case totalCount = "total_count"
    }
}

// MARK: - ConcernData
struct ConcernData: Codable {
    let count: Int
    let rows: [ConcernRow]?
}

// MARK: - ConcernRow
struct ConcernRow: Codable {
    let idx: Int
    let content, time: String
    let timer: Int?
    let subcategory: ConcernSubcategory
    let personalities: [NameData]?
    let dates: [ConcernRowData]?
    let status: String?
}

// MARK: - ConcernRowData
struct ConcernRowData: Codable {
    let date, fromTime, toTime, dateFormat: String

    enum CodingKeys: String, CodingKey {
        case date
        case fromTime = "from_time"
        case toTime = "to_time"
        case dateFormat = "date_format"
    }
}

// MARK: - NameData
struct NameData: Codable {
    let name: String
}

// MARK: - ConcernSubcategory
struct ConcernSubcategory: Codable {
    let name: String
    let category: NameData
}

// 재히 리스트보기
// [GET] ~/api/v1/asker/list/matches/:concern_idx
// MARK: - ConcernMatch
struct ConcernMatch: Codable {
    let code, message: String
    let data: [ConcernMatchRows]?
}

// MARK: - ConcernMatchRows
struct ConcernMatchRows: Codable {
    let idx: Int
    let willsoner: Willsoner
}

// MARK: - Willsoner
struct Willsoner: Codable {
    let avgRating: String?
    let idx: Int
    let experience: String?
    let asker: Asker
    let subcategories, keywords: [NameData]?
    let image: ImageData?

    enum CodingKeys: String, CodingKey {
        case avgRating = "avg_rating"
        case idx, experience, asker, subcategories, keywords, image
    }
}

// MARK: - Asker
struct Asker: Codable {
    let nickname: String
    let gender, age: String?
}

// 질문자 실시간 윌스너 상세보기
// GET /asker/list/matches/realtime/:match_idx

// MARK: - WillsonerDetail
struct WillsonerDetail: Codable {
    let code, message: String
    let data: WillsonerDetailData?
}

// MARK: - WillsonerDetailData
struct WillsonerDetailData: Codable {
    let match: WillsonerDetailMatch?
    let reviews: WillsonerDetailReviews?
}

// MARK: - WillsonerDetailMatch
struct WillsonerDetailMatch: Codable {
    let willsoner: WillsonerDetailWillsoner
}

// MARK: - WillsonerDetailWillsoner
struct WillsonerDetailWillsoner: Codable {
    let idx: Int
    let experience, introduction: String
    let asker: Asker
    let subcategories: [ConcernSubcategory]
    let image: ImageData?
    let keywords: [NameData]?
}

// MARK: - Reviews
struct WillsonerDetailReviews: Codable {
    let count: Int
    let rows: [ReviewsRow]?
    let avg: String?
}

// MARK: - Row
struct ReviewsRow: Codable {
    let idx: Int
    let title, content: String
    let rating: Double
    let category, date: String
}

// 윌스너 선택 (최종 수락)
// PATCH /asker/list/matches/1/select

// MARK: - MatchSuccess
struct MatchSuccess: Codable {
    let code, message: String
    let data: MatchSuccessData?
}

// MARK: - MatchSuccessData
struct MatchSuccessData: Codable {
    let createdAt, updatedAt, idx: Int?
    let status: String?
    let roomkey: String
    let concernIdx, willsonerIdx: Int?
    let dateIdx: Int?

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case idx, status, roomkey
        case concernIdx = "concern_idx"
        case willsonerIdx = "willsoner_idx"
        case dateIdx = "date_idx"
    }
}
