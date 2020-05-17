//
//  SignUpEmailViewController.swift
//  Willson
//
//  Created by JHKim on 22/09/2019.
//

import UIKit
import Toast_Swift

class SignUpEmailViewController: UIViewController {
    
    // MARK: - properties
    //    var delegate: SendToSexAndAgeDelegate?
    
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCheckButton(_ sender: Any) {
        // Userdefaults에 값 저장하기
        if let email = emailTextField.text {
            // 올바른 이메일 형식일 때 화면 전환
            if isValidEmail(email: email) {
                UserDefaults.standard.set(email, forKey: "email")
                UserDefaults.standard.set("email", forKey: "social")
                
                let vc = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "SignUpPasswordViewController")
                self.navigationController?.show(vc, sender: nil)
            }
            // 아니면 toast message 띄우기
            else {
                self.view.makeToast("잘못된 이메일 형식입니다.",
                duration: 2.0,
                position: .bottom,
                 style: ToastStyle())
            }
        }
    }
    
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
        
        // keyboard hide - view tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tap)
        
        // 처음에 버튼 비활성화
        checkButton.isEnabled = false
        
        // textfield delegate
        emailTextField.delegate = self
        
        // textfield 입력 감지 - 버튼 활성화
        emailTextField.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // remove keyboard notification center
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Methods
    func isValidEmail(email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }
}

extension SignUpEmailViewController: UITextFieldDelegate {
    
    //빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // textfield 입력 감지 - 버튼 활성화
    @objc func textChange(_ textField: UITextField) {
        if emailTextField.hasText {
            checkButton.isEnabled = true
        } else { checkButton.isEnabled = false }
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

/*
 protocol SendToSexAndAgeDelegate {
 func sendData(email: String, password: String)
 }
 */
