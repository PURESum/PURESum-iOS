//
//  WillsonerConcernServices.swift
//  Willson
//
//  Created by JHKim on 2020/05/19.
//

import Alamofire

struct WillsonerConcernServices {
    static let shared = WillsonerConcernServices()
    
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

