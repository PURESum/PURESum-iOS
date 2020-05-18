//
//  WillsonerConcernModels.swift
//  Willson
//
//  Created by JHKim on 2020/05/19.
//

import Foundation

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
