//
//  AskerMypageServices.swift
//  Willson
//
//  Created by JHKim on 2020/03/04.
//

import Alamofire

struct AskerMypageServices {
    static let shared = AskerMypageServices()
    
    // 마이페이지 (질문자)
    // /asker/mypage/home
    func getAskerMypageHome(completion: @escaping (AskerMypageHome) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // GET 통신
        Alamofire.request("\(SERVER_URL)/asker/mypage/home",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let mypageHome = try JSONDecoder().decode(AskerMypageHome.self, from: data)
                        completion(mypageHome)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 쿠폰 (질문자)
    // GET /asker/mypage/coupons
    func getAskerMypageCoupon(completion: @escaping(AskerMypageCoupon) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // GET 통신
        Alamofire.request("\(SERVER_URL)/asker/mypage/coupons",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let mypageCoupon = try JSONDecoder().decode(AskerMypageCoupon.self, from: data)
                        completion(mypageCoupon)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 상담 내역 (질문자)
    // GET /asker/mypage/matches
    func getAskerMypageHistory(completion: @escaping(AskerMypageHistory) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // GET 통신
        Alamofire.request("\(SERVER_URL)/asker/mypage/matches",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let mypageHistory = try JSONDecoder().decode(AskerMypageHistory.self, from: data)
                        completion(mypageHistory)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 내가 쓴 리뷰 (질문자)
    // GET /asker/mypage/reviews
    func getAskerMypageReviews(completion: @escaping(AskerMypageReview) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // GET 통신
        Alamofire.request("\(SERVER_URL)/asker/mypage/reviews",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let mypageReview = try JSONDecoder().decode(AskerMypageReview.self, from: data)
                        completion(mypageReview)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 공지사항 (질문자)
    // GET /asker/mypage/notices
    func getAskerMypageNotices(completion: @escaping(AskerMypageNotice) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // GET 통신
        Alamofire.request("\(SERVER_URL)/asker/mypage/notices",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let mypageNotice = try JSONDecoder().decode(AskerMypageNotice.self, from: data)
                        completion(mypageNotice)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
