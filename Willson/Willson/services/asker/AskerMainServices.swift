//
//  AskerMainServices.swift
//  Willson
//
//  Created by JHKim on 2020/03/24.
//

import Alamofire

struct AskerMainServices {
    static let shared = AskerMainServices()
    
    // 질문자 메인
    // GET /asker/main
    func getAskerMain(completion: @escaping(AskerMain) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                      "x-token": "\(token)"]
        Alamofire.request("\(SERVER_URL)/asker/main",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let main = try JSONDecoder().decode(AskerMain.self, from: data)
                        completion(main)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 질문자 추천 윌스너들
    // /asker/main/willsoners/:subcategory_idx
    func getWillsoners(subcategoryIndex: Int, completion: @escaping(AskerMainWillsoner) -> Void) {
        // 파라미터와 헤더 타입, 토큰 할당
//        let param = ["subcategory_idx": subcategoryIndex]
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                      "x-token": "\(token)"]
        Alamofire.request("\(SERVER_URL)/asker/main/willsoners/\(subcategoryIndex)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let willsoners = try JSONDecoder().decode(AskerMainWillsoner.self, from: data)
                        completion(willsoners)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
