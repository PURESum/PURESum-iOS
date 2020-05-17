//
//  LoginViewController.swift
//  Willson
//
//  Created by JHKim on 09/09/2019.
//

import UIKit
import FBSDKCoreKit
import FBSDKLoginKit
import Firebase
import Toast_Swift
import AuthenticationServices
import FirebaseAuth
import CommonCrypto

class LoginViewController: UIViewController {
    
    // MARK: - properties
    // 로그인 response model
    var signIn: SignIn?
    
    static let shared = LoginViewController()
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        // Create an indicator.
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        // Also show the indicator even when the animation is stopped.
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.white
        // Start animation.
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    // MARK: - IBOutlet
    @IBOutlet weak var 시작하기View: UIView!
    
    @IBOutlet weak var kakaoLoginButton: UIButton!
    @IBOutlet weak var facebookLoginButton: UIButton!
    @IBOutlet weak var emailLoginButton: UIButton!
    @IBOutlet weak var appleLoginButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedKakaotalkLogin(_ sender: Any) { // 카카오톡 로그인
        guard let session = KOSession.shared() else { return }
        
        // ensure old session was closed
        session.close()
        
        // 카카오톡 로그인만 허용 - 보류
        session.open { error in
            if session.isOpen() {
                // login success
                print("login succeeded.")
                
                // 사용자 정보 가져오기
                KOSessionTask.userMeTask(completion: { error, me in
                    if me != nil {
                        if let ID = me?.id {
                            print("사용자 아이디: \(ID)")
                            UserDefaults.standard.set(ID, forKey: "kakaoID")
                        }
                        if me?.account?.email != nil {
                            // 이메일 조회 성공
                            if let email = me?.account?.email {
                                print("사용자 이메일: \(email)")
                                // accessToken 가져오기
                                KOSessionTask.accessTokenInfoTask(completionHandler: { accessTokenInfo, error in
                                    if error != nil {
                                        switch (error as NSError?)?.code {
                                        case Int(KOErrorDeactivatedSession.rawValue)?:
                                                // 세션이 만료된(access_token, refresh_token이 모두 만료된 경우) 상태
                                            print("세션 만료 - error: \(String(describing: error))")
                                                break
                                            default:
                                                // 예기치 못한 에러. 서버 에러
                                                print("예기치 못한 에러 - error: \(String(describing: error))")
                                                break
                                        }
                                    } else {
                                        // 성공 (토큰이 유효함)
                                        if let expiresInMillis = accessTokenInfo?.expiresInMillis {
                                            print("남은 유효시간: \(expiresInMillis) (단위: ms)")
                                            
                                            // Userdefaults에 값 저장하기
                                            // email
                                            UserDefaults.standard.set(email, forKey: "email")
                                            // social
                                            UserDefaults.standard.set("kakao", forKey: "social")
                                            
                                            // willson 서버에 로그인 시도
                                            UserDefaults.standard.set(session.token.accessToken, forKey: "kakaoToken")
                                            guard let token = UserDefaults.standard.value(forKey: "kakaoToken") as? String else {
                                                print("kakaoToken 할당 오류")
                                                return
                                            }
                                            print("kakao access token: \(token)")
                                            self.loginToWillson(token: token, social: "kakao")
                                        }
                                    }
                                })
                            }
                        } else if me?.account?.emailNeedsAgreement != nil {
                            // 이메일 조회를 위해 사용자 동의가 필요한 상황
                            KOSession.shared().updateScopes(["account_email"], completionHandler: { error in
                                if error != nil {
                                    if (error as NSError?)?.code == Int(KOErrorCancelled.rawValue) {
                                        // 동의 안함
                                        print("동의 안함,,")
                                    } else {
                                        // 기타 에러
                                        print("error: \(String(describing: error))")
                                    }
                                } else {
                                    // 동의함
                                    // *** userMe를 다시 요청하면 이메일 획득 가능 ***
                                    // 토스트 띄우기
                                    print("동의 완료!")
                                    self.view.makeToast("카카오 로그인을 다시 시도해주세요.",
                                    duration: 3.0,
                                    position: .bottom,
                                     style: ToastStyle())
                                }
                            })
                        } else {
                            // 이메일 조회 불가능 (카카오계정 이메일 정보 없음)
                            print("이메일 조회 불가능")
                        }
                    } else {
                        if let error = error {
                            print("사용자 정보 요청 실패: \(error)")
                        }
                    }
                })
            } else {
                // failed
                print("login failed.")
            }
        }
    }
    
    @IBAction func tappedFBLogin(_ sender: Any) { // 페이스북 로그인
        let loginManager = LoginManager()
        loginManager.logIn(permissions: ["email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = AccessToken.current else {
                print("Failed to get access token")
                return
            }
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            // Perform login by calling Firebase APIs
            Auth.auth().signIn(with: credential) { [weak self] (authResult, error) in
                guard let strongSelf = self else { return }
                if let error = error {
                    print("Login error: \(error.localizedDescription)")
                    let alertController = UIAlertController(title: "Login Error", message: error.localizedDescription, preferredStyle: .alert)
                    let okayAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(okayAction)
                    strongSelf.present(alertController, animated: true, completion: nil)
                    return
                }
                // User is signed in
                print("===============")
                print("firebase 로그인 성공 !")
                print(Auth.auth().currentUser?.email ?? "")
                
                // idToken 가져오기
                let user = authResult?.user
                user?.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        // Handle error
                        print("=======================")
                        print(error.localizedDescription)
                        return
                    }
                    
                    guard let idToken = idToken else {
                        print("idToken 할당 오류")
                        return
                    }
                    // Userdefaults에 값 저장하기
                    // email
                    if let email = user?.email {
                        UserDefaults.standard.set(email, forKey: "email")
                    }
                    // social
                    UserDefaults.standard.set("facebook", forKey: "social")
                    
                    // willson 서버에 로그인 시도
                    strongSelf.loginToWillson(token: idToken, social: "facebook")
                }
            }
        }
    }
    
    // email login
    @IBAction func tappedEmailLogin(_ sender: Any) { // 이메일 로그인
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "EmailLoginNavigationController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // apple login
    @available(iOS 13.0, *)
    @IBAction func tappedAppleLogin(_ sender: Any) {
        // apple login
        FirebaseAuthentication.shared.signInWithApple(window: self.view.window ?? UIWindow())
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 로딩중
        self.view.addSubview(self.activityIndicator)
        
        // 애플 로그인
        /*
        if #available(iOS 13.0, *) {
            self.appleLoginButton.isHidden = false
        } else {
            // Fallback on earlier versions
            self.appleLoginButton.isHidden = true
        }
         */
        
        // UserDefault 삭제
        UserDefaults.standard.removeObject(forKey: "kakaoID")
    }
    
    // MARK: - Methods
    func loginToWillson(token: String, social: String) {
        // 로딩중 시작
        self.activityIndicator.startAnimating()
        
        AskerSignInService.shared.postSignIn(token: token, social: social, platform: "ios", pushToken: "asdfasdfasdf") { signIn, statusCode in
            // 4. 원래 회원이면 메인으로
            self.signIn = signIn
            if statusCode == 200 {
                print("=======================")
                print("\(social) 로그인 성공")
                // signin token 처리
                guard let token = self.signIn?.data?.accessToken else {
                    print("=======================")
                    print("acess token 할당 에러")
                    return
                }
                UserDefaults.standard.set(token, forKey: "token")
                
                let vc = UIStoryboard(name: "AskerTabbar", bundle: nil).instantiateViewController(withIdentifier: "AskerTabbarController")
                vc.modalPresentationStyle = .fullScreen
                var topController = UIApplication.shared.keyWindow?.rootViewController
                while ((topController?.presentedViewController) != nil) {
                    topController = topController?.presentedViewController
                }
                
                // 인디케이터 중지
                self.activityIndicator.stopAnimating()
                
                topController?.present(vc, animated: true, completion: nil)
            }
                // 5. 원래 회원이 아니면 response code 400 - 회원가입으로
            else if statusCode == 400 {
                if self.signIn?.code == "user_not_found" {
                    print("willson 서버 가입 하러 슝 !")
                    let vc = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "SignUpSexAndAgeViewController")
                    let navi = UINavigationController.init(rootViewController: vc)
                    navi.modalPresentationStyle = .fullScreen
                    navi.title = ""
                    
                    var topController = UIApplication.shared.keyWindow?.rootViewController
                    while ((topController?.presentedViewController) != nil) {
                        topController = topController?.presentedViewController
                    }
                    
                    // 인디케이터 중지
                    self.activityIndicator.stopAnimating()
                    
                    topController?.present(navi, animated: true, completion: nil)
                }
            }
        }
    }
}

