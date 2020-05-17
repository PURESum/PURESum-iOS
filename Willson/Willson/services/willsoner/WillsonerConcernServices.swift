//
//  WillsonerConcernServices.swift
//  Willson
//
//  Created by JHKim on 2020/03/04.
//

import Alamofire

struct WillsonerConcernServices {
    static let shared = WillsonerConcernServices()
    
    // 윌스너 실시간 요청 리스트
    // POST /willsoner/list/realtime/matches
    func postRealtimeMathes(categoryIndex: Int, completion: @escaping (Matches) -> Void) {
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
        Alamofire.request("\(SERVER_URL)/willsoner/list/realtime/matches",
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let matches = try JSONDecoder().decode(Matches.self, from: data)
                        completion(matches)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    /*
    // 실시간 요청 목록
    // GET /willsoner/list/realtime/matches
    func getmatches(completion: @escaping (Matches) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // GET 통신
        Alamofire.request("\(SERVER_URL)/willsoner/list/realtime/matches",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let matches = try JSONDecoder().decode(Matches.self, from: data)
                        completion(matches)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    */
    
    // 매칭 상세 페이지
    // GET willsoner/list/realtime/matches/:match_idx
    func getMatch(matchIndex: Int, completion: @escaping (Match) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // GET 통신
        Alamofire.request("\(SERVER_URL)/willsoner/list/realtime/matches/\(matchIndex)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let match = try JSONDecoder().decode(Match.self, from: data)
                        completion(match)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 매칭 수락
    // PATCH /willsoner/list/realtime/matches/:match_idx/select
    func patchSelect(matchIndex: Int, completion: @escaping (WillsonerRealtimeSelect) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // PATCH 통신
        Alamofire.request("\(SERVER_URL)/willsoner/list/realtime/matches/\(matchIndex)/select",
            method: .patch,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let select = try JSONDecoder().decode(WillsonerRealtimeSelect.self, from: data)
                        completion(select)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
