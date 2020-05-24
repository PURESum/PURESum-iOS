
//
//  LoginViewController.swift
//  MatchingService
//
//  Created by JHKim on 2020/05/24.
//  Copyright © 2020 zhi. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    // MARK: - properties
    
    // MARK: - IBOutlet
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var checkButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func changedSegmentedControl(_ sender: Any) {
    }
    
    @IBAction func tappedCheckButton(_ sender: Any) {
        
        guard let email = emailTextField.text else {
            print("email textfield 오류")
            return
        }
        guard let password = passwordTextField.text else {
            print("password textfield 오류")
            return
        }
        
        // firebase login 수행
        
        // 화면 전환
        let vc = UIStoryboard(name: "Tabbar", bundle: nil).instantiateViewController(withIdentifier: "tabbarController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
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
               passwordTextField.delegate = self
               // textfield 입력 감지 - 버튼 활성화
               emailTextField.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
               passwordTextField.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // remove keyboard notification center
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Methods
}

extension LoginViewController: UITextFieldDelegate {
    
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

