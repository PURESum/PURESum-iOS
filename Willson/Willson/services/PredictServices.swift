//
//  PredictServices.swift
//  Willson
//
//  Created by JHKim on 2020/05/18.
//

import Alamofire

struct PredictServices {
    static let shared = PredictServices()
    
    // 고민신청 - 세부 카테고리
    // POST /predict
    func postPredict(content: String, completion: @escaping (Predict) -> Void) {
        // 파라미터와 헤더 타입, 토큰 할당
        let params = ["content": content]
        let headers = ["Content-Type": "application/json"]
        
        // POST 통신
        Alamofire.request("\(SERVER_URL)/predict",
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let predict = try JSONDecoder().decode(Predict.self, from: data)
                        completion(predict)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}


