//
//  AskerSignIn.swift
//  Willson
//
//  Created by JHKim on 2020/01/06.
//

import Alamofire

struct AskerSignInService {
    static let shared = AskerSignInService()
    
    // 로그인
    // POST /asker/sign/signin
    func postSignIn(token: String, social: String, platform: String, pushToken: String, completion: @escaping (SignIn, Int) -> Void) {
        // 파라미터와 헤더 타입 정의
        let params = ["token": token,
                      "social": social,
                      "platform": platform,
                      "push_token": pushToken]
        let header = ["Content-Type" : "application/json"]
        // POST 통신
        Alamofire.request("\(SERVER_URL)/asker/sign/signin",
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: header).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let signIn = try JSONDecoder().decode(SignIn.self, from: data)
                        guard let statusCode = dataResponse.response?.statusCode else { return }
                        completion(signIn, statusCode)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
