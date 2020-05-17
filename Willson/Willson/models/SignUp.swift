//
//  SignUp.swift
//  Willson
//
//  Created by JHKim on 2020/01/06.
//

import Foundation

// 회원가입
// POST /asker/sign/signup

// MARK: - SignUp
struct SignUp: Codable {
    let code, message: String
    let data: SignUpData?
}

// MARK: - DataClass
struct SignUpData: Codable {
    let loginAt, createdAt, updatedAt, idx: Int
    let email, gender, age: String
    let nickname, accessToken, refreshToken, social: String
    let id: String?

    enum CodingKeys: String, CodingKey {
        case loginAt = "login_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case idx, email, gender, age, nickname, id, social
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
