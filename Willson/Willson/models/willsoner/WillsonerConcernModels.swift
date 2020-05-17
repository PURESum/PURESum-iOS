//
//  WillsonerConcernModels.swift
//  Willson
//
//  Created by JHKim on 2020/03/04.
//

import Foundation

// 실시간 요청 목록
// GET /willsoner/list/realtime/matches

// MARK: - Matches
struct Matches: Codable {
    let code, message: String
    let data: MatchesData?
}

// MARK: - MatchesData
struct MatchesData: Codable {
    let categories: [IdxData]
    let matches: MatchesDataClass?
}

// MARK: - MatchesDataClass
struct MatchesDataClass: Codable {
    let count: Int
    let rows: [MatchesRow]
}

// MARK: - Row
struct MatchesRow: Codable {
    let idx: Int
    let status: String
    let concern: MatchesConcern
}

// MARK: - Concern
struct MatchesConcern: Codable {
    let content, time: String
    let timer: Int
    let asker: Asker
    let subcategory: ConcernSubcategory
    let feelings: [NameData]
}

// 매칭 상세 페이지
// GET willsoner/list/realtime/matches/:match_idx

// MARK: - Match
struct Match: Codable {
    let code, message: String
    let data: MatchData?
}

// MARK: - DataClass
struct MatchData: Codable {
    let concern: MatchConcern
}

// MARK: - Concern
struct MatchConcern: Codable {
    let content: String
    let asker: Asker
    let subcategory: ConcernSubcategory
    let feelings: [NameData]
    let direction: NameData
}

// 매칭 수락
// PATCH /willsoner/list/realtime/matches/:match_idx/select

// MARK: - Select
struct WillsonerRealtimeSelect: Codable {
    let code, message: String
    let data: WillsonerRealtimeSelectData?
}

// MARK: - DataClass
struct WillsonerRealtimeSelectData: Codable {
    let createdAt, updatedAt, idx: Int
    let status: String
    let roomkey: String?
    let dateIdx: Int?
    let concernIdx, willsonerIdx: Int

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case idx, status, roomkey
        case dateIdx = "date_idx"
        case concernIdx = "concern_idx"
        case willsonerIdx = "willsoner_idx"
    }
}
