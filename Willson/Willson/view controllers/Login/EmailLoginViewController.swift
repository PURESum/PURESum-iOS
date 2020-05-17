//
//  EmailLoginViewController.swift
//  Willson
//
//  Created by JHKim on 15/09/2019.
//

import UIKit
import Firebase
import Toast_Swift

class EmailLoginViewController: UIViewController {
    
    // MARK: - properties
    //    var activeTextField = UITextField() // 활성화된 textfield
    // 로그인 networking service
    //    var signInService: AskerSignInService?
    // 로그인 response model
    var signIn: SignIn?
    
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
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkButton: CustomButton!
    
    // MARk: - IBAction
    @IBAction func tappedCancelBarButton(_ sender: Any) { // X 버튼
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedFindPasswordButton(_ sender: Any) {
        /*
         let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "FindPasswordNavi")
         vc.modalPresentationStyle = .fullScreen
         self.present(vc, animated: true, completion: nil)
         */
        self.view.makeToast("현재 버전에서 지원하지 않는 기능입니다.",
                            duration: 3.0,
                            position: .bottom,
                            style: ToastStyle())
    }
    
    @IBAction func tappedSignUpButton(_ sender: Any) { // 회원가입 하러가기 버튼
        let vc = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "SignUpNavi")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tappedCheckButton(_ sender: Any) {
        // 로딩중 시작
        self.activityIndicator.startAnimating()
        
        guard let email = emailTextField.text else {
            print("email textfield 오류")
            return
        }
        guard let password = passwordTextField.text else {
            print("password textfield 오류")
            return
        }
        // 1. firebase 로그인 - 토큰 받아오기
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let user = authResult?.user {
                user.getIDTokenForcingRefresh(true) { idToken, error in
                    if let error = error {
                        // Handle error
                        print("=======================")
                        print(error.localizedDescription)
                        
                        // 인디케이터 중지
                        strongSelf.activityIndicator.stopAnimating()
                        return
                    }
                    
                    guard let idToken = idToken else {
                        print("idToken 할당 오류")
                        
                        // 인디케이터 중지
                        strongSelf.activityIndicator.stopAnimating()
                        return
                    }
                    // 2. willson 서버 로그인
                    AskerSignInService.shared.postSignIn(token: idToken, social: "email", platform: "ios", pushToken: "asdfasdfasdf") { signIn, statusCode in
                        strongSelf.signIn = signIn
                        print("=======================")
                        print("로그인 통신 성공")
                        
                        // 3. signin token 처리
                        guard let token = strongSelf.signIn?.data?.accessToken else {
                            print("=======================")
                            print("acess token 할당 에러")
                            
                            // 인디케이터 중지
                            strongSelf.activityIndicator.stopAnimating()
                            return
                        }
                        print("=======================")
                        print(token)
                        UserDefaults.standard.set(token, forKey: "token")
                        
                        // 4. 화면 전환
                        let vc = UIStoryboard(name: "AskerTabbar", bundle: nil).instantiateViewController(withIdentifier: "AskerTabbarController")
                        vc.modalPresentationStyle = .fullScreen
                        strongSelf.present(vc, animated: true, completion: nil)
                    }
                }
            } else {
                // 회원가입 되지 않은 회원일 때 
                // 인디케이터 중지
                strongSelf.activityIndicator.stopAnimating()
                strongSelf.view.makeToast("다시 입력해 주세요.",
                                          duration: 3.0,
                                          position: .bottom,
                                          style: ToastStyle())
            }
        }
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 로그인 네트워크 서비스
        //        signInService = AskerSignInService()
        
        // add keyboard notification center
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil) // keyboard will show
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil) // keyboard will hide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // keyboard hide - view tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tap)
        
        // 처음에 버튼 비활성화
        checkButton.isEnabled = false
        
        // textfield delegate
        emailTextField.delegate = self
        passwordTextField.delegate = self
        // textfield 입력 감지 - 버튼 활성화
        emailTextField.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
        
        // 로딩중
        self.view.addSubview(self.activityIndicator)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // remove keyboard notification center
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Methods
    
}

extension EmailLoginViewController: UITextFieldDelegate {
    
    // 엔터 누르면 키보드 내리기
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1
        
        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    // textfield 입력 감지 - 버튼 활성화
    @objc func textChange(_ textField: UITextField) {
        if emailTextField.hasText && passwordTextField.hasText {
            checkButton.isEnabled = true
        } else { checkButton.isEnabled = false }
    }
    
    //빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // 키보드 올라 왔을 때 호출되는 함수
    @objc func keyboardWillShow(_ sender: Notification) {
        self.view.frame.origin.y = -150 // Move view 150 points upward
    }
    
    // 키보드 내려갈 때 호출되는 함수
    @objc func keyboardWillHide(_ sender: Notification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
}
