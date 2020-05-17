//
//  AskerSignInService.swift
//  Willson
//
//  Created by JHKim on 2019/12/31.
//

import Alamofire

struct SignUpService {
    static let shared = SignUpService()
    
    // 회원가입
    // POST /asker/sign/signup
    func postSignUp(token: String, email: String, gender: String, age: String, nickname: String, social: String, platform: String, pushToken: String, completion: @escaping (SignUp) -> Void) {
        // 파라미터와 헤더 타입 정의
        let params = ["token": token,
                      "email": email,
                      "gender": gender,
                      "age": age,
                      "nickname": nickname,
                      "social": social,
                      "push_token": pushToken]
        let header = ["Content-Type" : "application/json"]
        // POST 통신
        Alamofire.request("\(SERVER_URL)/asker/sign/signup",
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: header).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let signUp = try JSONDecoder().decode(SignUp.self, from: data)
                        completion(signUp)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
    }
}
