//
//  ChatModel.swift
//  Willson
//
//  Created by JHKim on 2020/02/07.
//

import Foundation
import ObjectMapper
import Firebase

// 채팅 내용
// firebase: chatrooms -> chats - document
class Comment: Mappable {
    var uid, message: String?
    var timeStamp: Timestamp?
    var readUser: [String: Bool]?

    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        uid <- map["uid"]
        message <- map["message"]
        timeStamp <- (map["timeStamp"])
        readUser <- map["readUser"]
    }
}

// 채팅방 목록 (질문자)
// GET /asker/chat/chatrooms
// MARK: - ChatRoom
struct ChatRoom: Codable {
    let code, message: String
    let data: ChatRoomData?
}

// MARK: - ChatRoomData
struct ChatRoomData: Codable {
    let count: Int
    let ing, reserve: [Ing]?
}

// MARK: - Ing
struct Ing: Codable {
    let idx: Int
    let roomkey: String
    let willsoner: ChatRoomWillsoner?
    let concern: IngData?
}

// MARK: - IngData
struct IngData: Codable {
    let time: String?
    let asker: IDData?
}

// MARK: - ChatRoomWillsoner
struct ChatRoomWillsoner: Codable {
    let idx: Int
    let asker: NicknameData
    let image: ChatRoomImage
}

// MARK: - IDData
struct IDData: Codable {
    let id: String
}

// MARK: - NicknameData
struct NicknameData: Codable {
    let nickname: String
}

// MARK: - ChatRoomImage
struct ChatRoomImage: Codable {
    let pic: String
}

// 채팅방 목록 (윌스너)
// GET /willsoner/chat/chatrooms
// MARK: - WillsonerChatRoom
struct WillsonerChatRoom: Codable {
    let code, message: String
    let data: WillsonerChatRoomData?
}

// MARK: - WillsonerChatRoomData
struct WillsonerChatRoomData: Codable {
    let count: Int
    let ing, reserve: [WillsonerIng]?
}

// MARK: - WillsonerIng
struct WillsonerIng: Codable {
    let idx: Int
    let roomkey: String
    let willsoner: WillsonerChatRoomWillsoner?
    let concern: WillsonerIngData?
}

// MARK: - WillsonerIngData
struct WillsonerIngData: Codable {
    let idx: Int
    let time: String?
    let asker: NicknameData?
}

// MARK: - WillsonerChatRoomWillsoner
struct WillsonerChatRoomWillsoner: Codable {
    let idx: Int
    let asker: IDData
}

// 질문자 대화 종료
// PATCH asker/chat/complete/:match_idx
// MARK: - ChatComplete
struct ChatComplete: Codable {
    let code, message: String
    let data: ChatCompleteData?
}

// MARK: - ChatCompleteData
struct ChatCompleteData: Codable {
    let createdAt, updatedAt, idx: Int
    let status: String
    let roomkey: String?
    let concernIdx: Int
    let dateIdx: Int?
    let willsonerIdx: Int

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case idx, status, roomkey
        case concernIdx = "concern_idx"
        case dateIdx = "date_idx"
        case willsonerIdx = "willsoner_idx"
    }
}

// 리뷰 - 이미지 선택
// GET asker/chat/review/image

// MARK: - AskerReviewImage
struct AskerReviewImage: Codable {
    let code, message: String
    let data: [ImageData]?
}

// 리뷰 작성 완료
// POST /asker/chat/review/complete

// MARK: - ReviewComplete
struct ReviewComplete: Codable {
    let code, message: String
    let data: ReviewCompleteData?
}

// MARK: - ReviewCompleteData
struct ReviewCompleteData: Codable {
    let createdAt, updatedAt, idx, matchIdx: Int
    let title, content: String
    let rating, imageIdx: Int

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case idx
        case matchIdx = "match_idx"
        case title, content, rating
        case imageIdx = "image_idx"
    }
}
