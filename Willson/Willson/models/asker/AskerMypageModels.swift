//
//  AskerMypageModels.swift
//  Willson
//
//  Created by JHKim on 2020/03/04.
//

import Foundation

// 마이페이지 (질문자)
// /asker/mypage/home

// MARK: - AskerMypageHome
struct AskerMypageHome: Codable {
    let code, message: String
    let data: AskerMypageHomeData?
}

// MARK: - AskerMypageHomeData
struct AskerMypageHomeData: Codable {
    let nickname, email: String
    // let ticketCnt: Int
    let point: Point?

    enum CodingKeys: String, CodingKey {
        case nickname, email
        // case ticketCnt = "ticket_cnt"
        case point
    }
}

// 쿠폰 (질문자)
// GET /asker/mypage/coupons

// MARK: - AskerMypageCoupon
struct AskerMypageCoupon: Codable {
    let code, message: String
    let data: CouponData?
}

// MARK: - CouponData
struct CouponData: Codable {
    let coupons: [Coupon]
}

// MARK: - Coupon
struct Coupon: Codable {
    let title, name, fromDate, toDate: String

    enum CodingKeys: String, CodingKey {
        case title, name
        case fromDate = "from_date"
        case toDate = "to_date"
    }
}


// 상담 내역 (질문자)
// GET /asker/mypage/matches

// MARK: - AskerMypageHistory
struct AskerMypageHistory: Codable {
    let code, message: String
    let data: [AskerMypageHistoryData]?
}

// MARK: - AskerMypageHistoryData
struct AskerMypageHistoryData: Codable {
    let idx: Int
    let date, category: String
    let willsoner: Willsoner
}

// 내가 쓴 리뷰 (질문자)
// GET /asker/mypage/reviews

// MARK: - AskerMypageReview
struct AskerMypageReview: Codable {
    let code, message: String
    let data: AskerMypageReviewData?
}

// MARK: - AskerMypageReviewData
struct AskerMypageReviewData: Codable {
    let count: Int
    let rows: [AskerMypageReviewRow]
}

// MARK: - AskerMypageReviewRow
struct AskerMypageReviewRow: Codable {
    let idx: Int
    let title, content: String
    let rating: Float
    let category, willsoner, date: String
    let image: ImageData?
}

// 공지사항 (질문자)
// GET /asker/mypage/notices

// MARK: - AskerMypageNotice
struct AskerMypageNotice: Codable {
    let code, message: String
    let data: [AskerMypageNoticeData]?
}

// MARK: - AskerMypageNoticeData
struct AskerMypageNoticeData: Codable {
    let title, content, date: String
}
