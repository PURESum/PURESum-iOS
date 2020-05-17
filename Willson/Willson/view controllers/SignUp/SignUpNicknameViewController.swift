//
//  SignUpNicknameViewController.swift
//  Willson
//
//  Created by JHKim on 2019/12/24.
//

import UIKit
import Firebase
import FBSDKCoreKit
import FBSDKLoginKit
import Toast_Swift
import AuthenticationServices
import FirebaseAuth

class SignUpNicknameViewController: UIViewController {
    
    static let shared = SignUpNicknameViewController()
    
    // MARK: - properties
    // firebase 인증
    var handle: AuthStateDidChangeListenerHandle?
    
    var idToken: String = ""
    
    // SignUp - 회원가입 response model
    var signUp: SignUp?
    
    /*
     var email: String?
     var password: String?
     var gender: String?
     var age: String?
     var nickname: String?
     */
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        // Create an indicator.
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color =  #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        // Also show the indicator even when the animation is stopped.
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.white
        // Start animation.
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    // MARK: - IBOutlet
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCheckButton(_ sender: Any) {
        // 로딩중 시작
        self.activityIndicator.startAnimating()
        
        // 회원가입 처리 - 서버 통신
        if let nickname = nicknameTextField.text {
            UserDefaults.standard.set(nickname, forKey: "nickname")
        }
        // fb
        guard let social = UserDefaults.standard.value(forKey: "social") as? String else {
            print("tappedCheckButton: social 할당 오류")
            return
        }
        print("tappedCheckButton: social - \(social)")
        if social == "email" {
            // email
            // 1. firebase 서버에 이메일, 비밀번호 유효 체크
            guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
                print("tappedCheckButton - email login: email 값 없음")
                return
            }
            guard let password = UserDefaults.standard.value(forKey: "password") as? String else {
                print("tappedCheckButton: password 값 없음")
                return
            }
            // 2. firebase 서버에 회원가입
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                guard let user = authResult?.user, error == nil else {
                    print("=======================")
                    print(error?.localizedDescription ?? "")
                    return
                }
                print("=======================")
                print("\(user.email ?? "") created")
                // 3. 회원가입된 유저의 토큰값으로 Willson 서버에 request
                self.postSignUp(user: user)
            }
        } else if social == "facebook" {
            // social - facebook
            // 회원가입된 유저의 토큰값으로 Willson 서버에 request
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
                guard let user = authResult?.user, error == nil else {
                    print("=======================")
                    print(error?.localizedDescription ?? "")
                    return
                }
                // 3. 회원가입된 유저의 토큰값으로 Willson 서버에 request
                strongSelf.postSignUp(user: user)
            }
        } else if social == "kakao" {
            guard let token = UserDefaults.standard.value(forKey: "kakaoToken") as? String else {
                print("kakaoToken 할당 오류")
                return
            }
            self.idToken = token
            print("self.idToken - kakao: \(self.idToken)")
            // userdefault 초기화
//            UserDefaults.standard.removeObject(forKey: "kakaoToken")
            // 3-1, 4. Willson 서버에 request
            self.signUpToWillson()
        } else if social == "apple" {
            // social - apple
            // 회원가입된 유저의 토큰값으로 Willson 서버에 request
            // apple login
            if #available(iOS 13.0, *) {
                FirebaseAuthentication.shared.signInWithApple(window: self.view.window ?? UIWindow())
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // firebase 리스너 연결
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            // SignUp Network Service
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 처음에 버튼 비활성화
        checkButton.isEnabled = false
        
        // keyboard hide - view tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tap)
        
        // textfield delegate
        nicknameTextField.delegate = self
        // textfield 입력 감지 - 버튼 활성화
        nicknameTextField.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
        
        // 로딩중
        self.view.addSubview(self.activityIndicator)

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // firebase 리스너 분리
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    // MARK: - Methods
    func postSignUp(user: User) {
        // 3. 회원가입된 유저의 토큰값으로 Willson 서버에 request
        user.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                // Handle error
                print("=======================")
                print(error.localizedDescription)
                return
            }
            guard let idToken = idToken else {
                print("idToken 할당 에러")
                return }
            self.idToken = idToken
            print("=======================")
            print("self.idToken: \(self.idToken)")
            // 4. request 완료되면 회원가입 최종완료
            self.signUpToWillson()
        }
    }
    
    func signUpToWillson() {
        // userdefault 처리
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            print("signUpToWillson: email 값 없음")
            return
        }
        guard let age: String = UserDefaults.standard.value(forKey: "age") as? String else {
            print("UserDefaults.standard.value(forKey: \"age\") 할당 오류")
            return }
        guard let gender: String = UserDefaults.standard.value(forKey: "gender") as? String else {
            print("UserDefaults.standard.value(forKey: \"gender\") 할당 오류")
            return }
        guard let nickname: String = UserDefaults.standard.value(forKey: "nickname") as? String else {
            print("UserDefaults.standard.value(forKey: \"nickname\") 할당 오류")
            return }
        guard let social: String = UserDefaults.standard.value(forKey: "social") as? String else {
        print("UserDefaults.standard.value(forKey: \"social\") 할당 오류")
        return }
        
        if social == "apple" {
            guard let IDToken: String = UserDefaults.standard.value(forKey: "IDToken") as? String else{
                print("UserDefaults.standard: token 할당 오류")
                return
            }
            self.idToken = IDToken
        }
        
        SignUpService.shared.postSignUp(token: idToken, email: email, gender: gender, age: age, nickname: nickname, social: social, platform: "ios", pushToken: "asdfasdfasdf") { signUp in
            self.signUp = signUp
            print("=======================")
            print("회원가입 통신 성공")
            
            // 5. userdefault 초기화
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.removeObject(forKey: "password")
            UserDefaults.standard.removeObject(forKey: "age")
            UserDefaults.standard.removeObject(forKey: "gender")
            UserDefaults.standard.removeObject(forKey: "nickname")
            // social 값은 초기화 시키지 않음
            
            var topController = UIApplication.shared.keyWindow?.rootViewController
            while ((topController?.presentedViewController) != nil) {
                topController = topController?.presentedViewController
                }
            
            // 인디케이터 중지
            if topController == self {
                topController?.dismiss(animated: true, completion: nil)
            }
            
            // 6. 화면 전환
            topController?.view.makeToast("회원가입 완료! 로그인 해주세요.",
            duration: 3.0,
            position: .bottom,
             style: ToastStyle())
            
            topController?.dismiss(animated: true, completion: nil)
        }
    }
}

extension SignUpNicknameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // textfield 입력 감지 - 버튼 활성화
    @objc func textChange(_ textField: UITextField) {
        if nicknameTextField.hasText {
            checkButton.isEnabled = true
        } else { checkButton.isEnabled = false }
    }
}
