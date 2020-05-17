//
//  SignIn.swift
//  Willson
//
//  Created by JHKim on 2020/01/06.
//

import Foundation

// 로그인
// POST /asker/sign/signin

// MARK: - SignIn
struct SignIn: Codable {
    let code, message: String?
    let data: SignInData?
}

// MARK: - DataClass
struct SignInData: Codable {
    let loginAt, createdAt, updatedAt, idx: Int
    let id, email, gender, age: String
    let status: String?
    let nickname, accessToken, refreshToken: String

    enum CodingKeys: String, CodingKey {
        case loginAt = "login_at"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case idx, id, email, gender, age, nickname, status
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}
