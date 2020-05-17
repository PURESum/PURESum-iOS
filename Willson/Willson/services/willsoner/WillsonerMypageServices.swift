//
//  WillsonerMypageServices.swift
//  Willson
//
//  Created by JHKim on 2020/03/04.
//

import Alamofire

struct WillsonerMypageServices {
    static let shared = WillsonerMypageServices()
    
    // 마이페이지 (윌스너)
    // /willsoner/mypage/home
    func getWillsonerMypageHome(completion: @escaping (WillsonerMypageHome) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // GET 통신
        Alamofire.request("\(SERVER_URL)/willsoner/mypage/home",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let mypageHome = try JSONDecoder().decode(WillsonerMypageHome.self, from: data)
                        completion(mypageHome)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
