//
//  SignUpViewController.swift
//  MatchingService
//
//  Created by JHKim on 2020/05/28.
//  Copyright © 2020 zhi. All rights reserved.
//

import UIKit
import Toast_Swift
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    // MARK: - properties
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
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var PWTextField: UITextField!
    @IBOutlet weak var PWLabel: UILabel!
    
    @IBOutlet weak var checkPWLabel: UILabel!
    @IBOutlet weak var checkPWField: UITextField!
    
    @IBOutlet weak var completeButtonItem: UIBarButtonItem!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedCompleteButtonItem(_ sender: Any) {
        // 로딩중 시작
        self.activityIndicator.startAnimating()
        
        // 1. firebase 서버에 이메일, 비밀번호 유효 체크
        UserDefaults.standard.set(emailTextField.text, forKey: "email")
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else {
            print("tappedCheckButton - email login: email 값 없음")
            return
        }
        UserDefaults.standard.set(PWTextField.text, forKey: "password")
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
            
            // 화면 전환
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add keyboard notification center
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil) // keyboard will show
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil) // keyboard will hide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 로딩중
        self.view.addSubview(self.activityIndicator)
        
        // keyboard hide - view tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tap)
        
        // 처음에 버튼 비활성화
        completeButtonItem.isEnabled = false
        
        // textfield delegate
        emailTextField.delegate = self
        PWTextField.delegate = self
        checkPWField.delegate = self
        
        // textfield 입력 감지 - 버튼 활성화
        emailTextField.addTarget(self, action: #selector(emailChanged(_:)), for: .editingChanged)
        PWTextField.addTarget(self, action: #selector(PWChanged(_:)), for: .editingChanged)
        checkPWField.addTarget(self, action: #selector(checkPWChanged(_:)), for: .editingChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // remove keyboard notification center
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Methods
    // 올바른 이메일 형식인지 확인
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
    
    func checkAllInfoFilled() {
        if let email = emailTextField.text, let pw = PWTextField.text, let checkPW = checkPWField.text {
            if isValidEmail(email: email) && pw.count >= 6 && pw == checkPW {
                completeButtonItem.isEnabled = true
            } else {
                completeButtonItem.isEnabled = false
            }
        } else {
            completeButtonItem.isEnabled = false
        }
    }
}

// MARK: - UITextFieldDelegate
extension SignUpViewController: UITextFieldDelegate {
    
    //빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // textfield 입력 감지 - 버튼 활성화
    @objc func emailChanged(_ textField: UITextField) {
        if let email = textField.text {
            checkAllInfoFilled()
            // 올바른 이메일 형식
            if isValidEmail(email: email) {
                emailLabel.isHidden = true
            }
                // 아니면
            else {
                emailLabel.isHidden = false
            }
        }
    }
    
    @objc func PWChanged(_ textField: UITextField) {
        if let pw = textField.text {
            checkAllInfoFilled()
            // 6자리 이상인지 확인
            if pw.count >= 6 {
                PWLabel.isHidden = true
            }
                // 아니면
            else {
                PWLabel.isHidden = false
            }
        }
    }
    
    @objc func checkPWChanged(_ textField: UITextField) {
        if let pw = PWTextField.text, let checkpw = textField.text {
            checkAllInfoFilled()
            // 6자리 이상인지 확인
            if pw == checkpw {
                checkPWLabel.isHidden = true
            }
                // 아니면
            else {
                checkPWLabel.isHidden = false
            }
        }
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
