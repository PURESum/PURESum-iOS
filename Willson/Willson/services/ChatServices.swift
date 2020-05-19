//
//  ChatServices.swift
//  Willson
//
//  Created by JHKim on 2020/02/06.
//

import Alamofire

struct ChatServices {
    static let shared = ChatServices()
    
    // 채팅방 목록 (질문자)
    // GET /asker/chat/chatrooms
    func askerGetChatRooms(completion: @escaping (ChatRoom) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // GET 통신
        Alamofire.request("\(SERVER_URL)/asker/chat/chatrooms",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let chatRoom = try JSONDecoder().decode(ChatRoom.self, from: data)
                        completion(chatRoom)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 채팅방 목록 (윌스너)
    // GET /willsoner/chat/chatrooms
    func willonerGetChatRooms(completion: @escaping (WillsonerChatRoom) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // GET 통신
        Alamofire.request("\(SERVER_URL)/willsoner/chat/chatrooms",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let chatRoom = try JSONDecoder().decode(WillsonerChatRoom.self, from: data)
                        completion(chatRoom)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 질문자 대화 종료
    // PATCH asker/chat/complete/:match_idx
    func patchChatComplete(matchIndex: Int, completion: @escaping (ChatComplete) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // PATCH 통신
        Alamofire.request("\(SERVER_URL)/asker/chat/complete/\(matchIndex)",
            method: .patch,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let chatComplete = try JSONDecoder().decode(ChatComplete.self, from: data)
                        completion(chatComplete)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 리뷰 - 이미지 선택
    // GET asker/chat/review/image
    func getAskerReviewImage(completion: @escaping (AskerReviewImage) -> Void) {
        // 헤더 타입 및 토큰 할당
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("===================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // GET 통신
        Alamofire.request("\(SERVER_URL)/asker/chat/review/image",
            method: .get,
            parameters: nil,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let reviewImage = try JSONDecoder().decode(AskerReviewImage.self, from: data)
                        completion(reviewImage)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
    
    // 리뷰 작성 완료
    // POST /asker/chat/review/complete
    func postReviewComplete(matchIndex: Int, willsonerIndex: Int, title: String, content: String, rating: Float, imageIndex: Int, completion: @escaping (ReviewComplete) -> Void) {
        // 파라미터와 헤더 타입, 토큰 할당
        let params = ["match_idx": matchIndex,
                      "title": title,
                      "content": content,
                      "rating": rating,
                      "image_idx": imageIndex
            ] as [String : Any]
        guard let token = UserDefaults.standard.value(forKey: "token") else {
            print("=================")
            print("UserDefaults - token 할당 오류")
            return
        }
        let headers = ["Content-Type": "application/json",
                       "x-token": "\(token)"]
        // POST 통신
        Alamofire.request("\(SERVER_URL)/asker/chat/review/complete",
            method: .post,
            parameters: params,
            encoding: JSONEncoding.default,
            headers: headers).responseData { dataResponse in
                switch dataResponse.result {
                case .success(let data):
                    do {
                        let reviewComplete = try JSONDecoder().decode(ReviewComplete.self, from: data)
                        completion(reviewComplete)
                    } catch {
                        print("Got and error: \(error)")
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
        }
    }
}
