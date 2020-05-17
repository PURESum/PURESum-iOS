//
//  SignUpPasswordViewController.swift
//  Willson
//
//  Created by JHKim on 2020/01/06.
//

import UIKit

class SignUpPasswordViewController: UIViewController {

    // MARK:- properties
    
    // MARK: - IBOutlet
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkPasswordTextField: UITextField!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    @IBOutlet weak var checkButton: CustomButton!
    
    // MARK: - IBAction
    @IBAction func tappedNextButton(_ sender: Any) {
        if let password = passwordTextField.text {
            UserDefaults.standard.set(password, forKey: "password")
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
        
        // 처음에 버튼, 메시지 레이블 비활성화
        checkButton.isEnabled = false
        messageLabel.isHidden = true
        
        // textfield delegate
        passwordTextField.delegate = self
        checkPasswordTextField.delegate = self
        
        // textfield 입력 감지 - 버튼 활성화
        passwordTextField.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
        checkPasswordTextField.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // remove keyboard notification center
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Methods
}

extension SignUpPasswordViewController: UITextFieldDelegate {
    
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
    
    //빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // textfield 입력 감지 - 버튼 활성화
    @objc func textChange(_ textField: UITextField) {
        /*
        if passwordTextField.hasText {
            if let count = checkPasswordTextField.text?.count {
                if count >= 6 {
                    if checkPasswordTextField.hasText {
                        if passwordTextField.text == checkPasswordTextField.text {
                            messageLabel.isHidden = true
                            checkButton.isEnabled = false
                        } else {
                            messageLabel.isHidden = false
                            messageLabel.text = "비밀번호가 일치하지 않습니다."
                            checkButton.isEnabled = false
                        }
                    } else {
                        messageLabel.isHidden = true
                        checkButton.isEnabled = false
                    }
                } else {
                    messageLabel.isHidden = false
                    messageLabel.text = "6자리 이상 입력해주세요."
                    checkButton.isEnabled = false
                }
            }
        } else {
            messageLabel.isHidden = true
            checkButton.isEnabled = false
        }
         */
        if passwordTextField.hasText && checkPasswordTextField.hasText && (passwordTextField.text == checkPasswordTextField.text) {
            checkButton.isEnabled = true
        } else {
            checkButton.isEnabled = false
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
