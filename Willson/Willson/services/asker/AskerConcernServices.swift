//
//  AskerConcernServices.swift
//  Willson
//
//  Created by JHKim on 2020/03/04.
//

import Alamofire

struct AskerConcernServices {
    static let shared = AskerConcernServices()
    
    // 재히 리스트보기
    // [GET] ~/api/v1/asker/list/matches/:concern_idx
    func getWillsonerList(concernIndex: Int, completion: @escaping (ConcernMatch) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                      "x-token": "\(token)"]
        // GET 통신
        Alamofire.request("\(SERVER_URL)/api/v1/asker/list/matches/\(concernIndex)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let concernMatch = try JSONDecoder().decode(ConcernMatch.self, from: data)
                        completion(concernMatch)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    /*
    // 고민에 대한 윌스너 매치 목록
    // POST /asker/list/concerns/:concern_idx/matches
    func postWillsonerList(index: Int, completion: @escaping (ConcernMatch) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // POST 통신
        Alamofire.request("\(SERVER_URL)/asker/list/concerns/\(index)/matches",
            method: .post,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let concernMatch = try JSONDecoder().decode(ConcernMatch.self, from: data)
                        completion(concernMatch)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    */
    
    // 질문자 실시간 윌스너 상세보기
    // GET /asker/list/matches/realtime/:match_idx
    func getWillsonerDetail(matchIndex: Int, completion: @escaping (WillsonerDetail) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        
        // GET 통신
        Alamofire.request("\(SERVER_URL)/asker/list/matches/realtime/\(matchIndex)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let willsonerDetail = try JSONDecoder().decode(WillsonerDetail.self, from: data)
                        completion(willsonerDetail)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    /*
    // 윌스너 세부 페이지
    // GET /asker/list/concerns/matches/:match_idx
    func getWillsonerDetail(matchIndex: Int, completion: @escaping (WillsonerDetail) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        
        // GET 통신
        Alamofire.request("\(SERVER_URL)/asker/list/concerns/matches/\(matchIndex)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let willsonerDetail = try JSONDecoder().decode(WillsonerDetail.self, from: data)
                        completion(willsonerDetail)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    */
    
    // 윌스너 선택 (최종 수락)
    // PATCH /asker/list/matches/1/select
    func patchMatchSuccess(matchIndex: Int, completion: @escaping (MatchSuccess) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // PATCH 통신
        Alamofire.request("\(SERVER_URL)/asker/list/matches/\(matchIndex)/select",
            method: .patch,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let matchSuccess = try JSONDecoder().decode(MatchSuccess.self, from: data)
                        completion(matchSuccess)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
