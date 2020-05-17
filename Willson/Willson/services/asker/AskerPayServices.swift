//
//  AskerPayServices.swift
//  Willson
//
//  Created by JHKim on 2020/04/02.
//

import Alamofire

struct AskerPayServices {
    static let shared = AskerPayServices()
    
    // 고민결제
    // GET /asker/payment/:concern_idx
    func getPayment(concernIdx: Int, completion: @escaping (AskerPay) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let header = ["Content-Type": "application/json",
                      "x-token": "\(token)"]
        // GET 통신
        Alamofire.request("\(SERVER_URL)/asker/payment/\(concernIdx)",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: header).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let askerPay = try JSONDecoder().decode(AskerPay.self, from: data)
                        completion(askerPay)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 고민 결제 3
    // POST /asker/payment/purchase
    func postPurchase(ticketIndex: Int, completion: @escaping (AskerPay3) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // 파라미터 할당
        let param = ["ticket_idx": ticketIndex]
        
        // POST 통신
        Alamofire.request("\(SERVER_URL)/asker/payment/purchase",
            method: .post,
            parameters: param,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let pay3 = try JSONDecoder().decode(AskerPay3.self, from: data)
                        completion(pay3)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 최종결제
    // POST /asker/payment/:concern_idx
    func postPay(concernIndex: Int, ticketIndex: Int, completion: @escaping (AskerPayComplete) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // 파라미터 할당
        let param = ["ticket_idx": ticketIndex]
        
        // POST 통신
        Alamofire.request("\(SERVER_URL)/asker/payment/\(concernIndex)",
            method: .post,
            parameters: param,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let payComplete = try JSONDecoder().decode(AskerPayComplete.self, from: data)
                        completion(payComplete)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
