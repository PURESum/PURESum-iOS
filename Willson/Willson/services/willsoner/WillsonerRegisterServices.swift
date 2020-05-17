//
//  WillsonerRegisterServices.swift
//  Willson
//
//  Created by JHKim on 2020/03/04.
//

import Alamofire

struct WillsonerRegisterServices {
    static let shared = WillsonerRegisterServices()
    
    // 윌스너 신청 - 세부 카테고리
    // POST willsoner/register/subcategory
    func postSubCategory(categoryIndex: Int, completion: @escaping (BasicModel) -> Void) {
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
        Alamofire.request("\(SERVER_URL)/willsoner/register/subcategory",
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let subCategory = try JSONDecoder().decode(BasicModel.self, from: data)
                        completion(subCategory)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 윌스너 해시태그
    // POST /willsoner/register/keyword
    func postHashTag(categoryIndex: Int, keywords: [String], completion: @escaping (HashTag) -> Void) {
        // 파라미터와 헤더 타입, 토큰 할당
        let params = ["category_idx": categoryIndex,
                      "keyword_data": keywords] as [String : Any]
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                      "x-token": "\(token)"]
        // POST 통신
        Alamofire.request("\(SERVER_URL)/willsoner/register/keyword",
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let hashtag = try JSONDecoder().decode(HashTag.self, from: data)
                        completion(hashtag)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 윌스너 신청 - 이미지
    // GET willsoner/register/image
    func getImage(completion: @escaping (Image) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                      "x-token": "\(token)"]
        
        Alamofire.request("\(SERVER_URL)/willsoner/register/image",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let image = try JSONDecoder().decode(Image.self, from: data)
                        completion(image)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 핸드폰 인증번호 요청
    // POST /willsoner/register/phone/verify
    func postPhoneVerify(phone: String, completion: @escaping (PhoneVerify) -> Void) {
        // 파라미터와 헤더 타입, 토큰 할당
        let params = ["phone": phone]
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                      "x-token": "\(token)"]
        // POST 통신
        Alamofire.request("\(SERVER_URL)/willsoner/register/phone/verify",
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let phoneVerify = try JSONDecoder().decode(PhoneVerify.self, from: data)
                        completion(phoneVerify)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 핸드폰 인증번호 확인
    // POST /willsoner/register/phone/check
    func postPhoneCheck(phone: String, code: String, completion: @escaping (PhoneVerify) -> Void) {
        // 파라미터와 헤더 타입, 토큰 할당
        let params = ["phone": phone,
                      "code": code]
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                      "x-token": "\(token)"]
        // POST 통신
        Alamofire.request("\(SERVER_URL)/willsoner/register/phone/check",
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let phoneVerify = try JSONDecoder().decode(PhoneVerify.self, from: data)
                        completion(phoneVerify)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 헬퍼등록 완료
    // POST /willsoner/register/complete
    func postRegisterComplete(subCategoryIndex: Int, experience: String, keywordIndex: [Int], introduction: String, imageIndex: Int, auth_licence: String?, auth_media: String?, auth_phone: String?, auth_email: String?, completion: @escaping (RegisterComplete) -> Void) {
        // 파라미터와 헤더 타입, 토큰 할당
        let params = ["subcategory_idx": subCategoryIndex,
                      "experience": experience,
                      "keyword_idx": keywordIndex,
                      "introduction": introduction,
                      "image_idx": imageIndex,
                      "auth_licence": auth_licence ?? "",
                      "auth_media": auth_media ?? "",
                      "auth_phone": auth_phone ?? "",
                      "auth_email": auth_email ?? ""]
            as [String : Any]
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                      "x-token": "\(token)"]
        // POST 통신
        Alamofire.request("\(SERVER_URL)/willsoner/register/complete",
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let registerComplete = try JSONDecoder().decode(RegisterComplete.self, from: data)
                        completion(registerComplete)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
