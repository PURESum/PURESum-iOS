//
//  AskerRequestServices.swift
//  Willson
//
//  Created by JHKim on 2020/03/04.
//

import Alamofire

struct AskerRequestServices {
    static let shared = AskerRequestServices()
    
    // 고민신청 - 세부 카테고리
    // POST asker/request/subcategory
    func postSubCategory(categoryIndex: Int, completion: @escaping (BasicModel) -> Void) {
        // 파라미터와 헤더 타입, 토큰 할당
        let params = ["category_idx": categoryIndex]
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                      "x-token": "\(token)"]
        // POST 통신
        Alamofire.request("\(SERVER_URL)/asker/request/subcategory",
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let subCategory = try JSONDecoder().decode(BasicModel.self, from: data)
                        completion(subCategory)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 고민신청 - 감정
    // GET asker/request/feeling
    func getFeeling(completion: @escaping (BasicModel) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                      "x-token": "\(token)"]
        Alamofire.request("\(SERVER_URL)/asker/request/feeling",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let feeling = try JSONDecoder().decode(BasicModel.self, from: data)
                        completion(feeling)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 고민신청 - 헬퍼 성격
    // GET asker/request/willsoner_type
    func getWillsonerType(completion: @escaping (BasicModel) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let header = ["Content-Type": "application/json",
                      "x-token": "\(token)"]
        // GET 통신
        Alamofire.request("\(SERVER_URL)/asker/request/willsoner_type",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: header).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let willsonerType = try JSONDecoder().decode(BasicModel.self, from: data)
                        completion(willsonerType)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 고민 신청 - 대화 방향
    // GET asker/request/direction
    func getDirection(completion: @escaping (BasicModel) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let header = ["Content-Type": "application/json",
                      "x-token": "\(token)"]
        // GET 통신
        Alamofire.request("\(SERVER_URL)/asker/request/direction",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: header).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let direction = try JSONDecoder().decode(BasicModel.self, from: data)
                        completion(direction)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 고민신청 완료
    // POST /asker/request/complete
    func postRequestComplete(subCategoryIdx: Int, feelingIdx: [Int], keywordIdx: [Int], content: String, willGender: String, personalityIdx: [Int], directionIdx: Int, type: String, fromDate: String, toDate: String, time: String, agreement: Int, completion: @escaping (RequestComplete) -> Void) {
        // 파라미터와 헤더 타입, 토큰 할당
        let params = ["subcategory_idx": subCategoryIdx,
                      "feeling_idx": feelingIdx,
                      "keyword_idx": keywordIdx,
                      "content": content,
                      "wil_gender": willGender,
                      "personality_idx": personalityIdx,
                      "direction_idx": directionIdx,
                      "type": type,
                      "from_date": fromDate,
                      "to_date": toDate,
                      "time": time,
                      "agreement": agreement] as [String : Any]
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                      "x-token": "\(token)"]
        // POST 통신
        Alamofire.request("\(SERVER_URL)/asker/request/complete",
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let requestComplete = try JSONDecoder().decode(RequestComplete.self, from: data)
                        completion(requestComplete)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
