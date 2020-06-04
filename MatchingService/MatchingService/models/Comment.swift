//
//  Comment.swift
//  MatchingService
//
//  Created by JHKim on 2020/06/04.
//  Copyright © 2020 zhi. All rights reserved.
//

import ObjectMapper
import Firebase

// 채팅 내용
// firebase: chatrooms -> chats - document
class Comment: Mappable {
    var uid, message: String?
    var timeStamp: Timestaㅏmp?
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
