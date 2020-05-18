//
//  AskerRequestServices.swift
//  Willson
//
//  Created by JHKim on 2020/03/04.
//

import Alamofire

struct AskerRequestServices {
    static let shared = AskerRequestServices()
    
    // 고민신청 완료
    // POST /asker/request/complete
    func postRequestComplete(content: String, completion: @escaping (RequestComplete) -> Void) {
        // 파라미터와 헤더 타입, 토큰 할당
        let params = ["content": content]
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
    
    // 재희 매칭
    // [POST] ~/api/v1/asker/list/matches/:concern_idx
    func postMatchPredict(concernIndex: Int, willsonerIndex: [Int], completion: @escaping(MatchPredict) -> Void) {
        // 파라미터와 헤더 타입, 토큰 할당
        let params = ["willsoner_idx": willsonerIndex]
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                      "x-token": "\(token)"]
        // POST 통신
        Alamofire.request("\(SERVER_URL)/api/v1/asker/list/matches/\(concernIndex)",
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let matchPredict = try JSONDecoder().decode(MatchPredict.self, from: data)
                        completion(matchPredict)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
