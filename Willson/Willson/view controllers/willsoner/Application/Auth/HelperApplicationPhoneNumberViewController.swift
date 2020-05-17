//
//  HelperApplicationPhoneNumberViewController.swift
//  Willson
//
//  Created by JHKim on 2019/11/13.
//

import UIKit
import Toast_Swift

class HelperApplicationPhoneNumberViewController: UIViewController {
    
    // MARK: - properties
    // phone response model
    var phoneVerify: PhoneVerify?
    var phoneCheck: PhoneVerify?
    
    // complete response model
    var registerComplete: RegisterComplete?
    
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
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    @IBOutlet weak var requestButton: UIButton!
    
    @IBOutlet weak var verifyNumberTextField: UITextField!
    
    @IBOutlet weak var completeButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedRequestButton(_ sender: Any) {
        guard let phone = phoneNumberTextField.text else {
            print("phone number textfield text 할당 오류")
            return
        }
        
        UserDefaults.standard.set(phone, forKey: "phone")
        
        // 키보드 내리게
        self.phoneNumberTextField.resignFirstResponder()
        
        WillsonerRegisterServices.shared.postPhoneVerify(phone: phone) { phoneVerify in
            self.phoneVerify = phoneVerify
            print("==============")
            print("핸드폰 인증 요청 성공 ! ")
            
            self.view.makeToast("인증번호가 전송 되었습니다.",
            duration: 3.0,
            position: .bottom,
             style: ToastStyle())
        }
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        /*
        let vc = UIStoryboard(name: "HelperApplication", bundle: nil).instantiateViewController(withIdentifier: "HelperApplicationAdditionalAuthViewController")
        self.navigationController?.show(vc, sender: nil)
        */
        // 인증번호 확인
        guard let phone = UserDefaults.standard.value(forKey: "phone") as? String else {
            print("UserDefaults - phone 할당 오류")
            return
        }
        guard let code = verifyNumberTextField.text else {
            print("인증번호 오류")
            return
        }
        
        WillsonerRegisterServices.shared.postPhoneCheck(phone: phone, code: code) { phoneCheck in
            self.phoneCheck = phoneCheck
            print("================")
            print("인증번호 확인 통신 성공 !")
            
            // 인디케이터 시작
            // 로딩중 시작
            self.activityIndicator.startAnimating()
            
            self.view.makeToast("인증번호 확인 성공 !",
            duration: 2.0,
            position: .bottom,
             style: ToastStyle())
            
            // 가입 신청
            guard let categoryIndex = UserDefaults.standard.value(forKey: "categoryIndex") as? Int else {
                print("UserDefaults - categoryIndex 할당 오류")
                return
            }
            print("UserDefaults - categoryIndex: \(categoryIndex)")
            
            guard let subCategoryIndex = UserDefaults.standard.value(forKey: "subCategoryIndex") as? Int else {
                print("UserDefaults - subCategoryIndex 할당 오류")
                return
            }
            print("UserDefaults - subCategoryIndex \(subCategoryIndex)")
            
            guard let experience = UserDefaults.standard.value(forKey: "experience") as? String else {
                print("UserDefaults - experience 할당 오류")
                return
            }
            print("UserDefaults - experience: \(experience)")
            
            guard let keywordIndex = UserDefaults.standard.value(forKey: "keywordIndex") as? [Int] else {
                print("UserDefaults - keywordIndex 할당 오류")
                return
            }
            print("UserDefualts - keywordIndex: \(keywordIndex)")
            
            guard let introduction = UserDefaults.standard.value(forKey: "introduction") as? String else {
                print("UserDefaults - introduction 할당 오류")
                return
            }
            print("UserDefaults - introduction: \(introduction)")
            guard let imageIndex = UserDefaults.standard.value(forKey: "imageIndex") as? Int else {
                print("UserDefaults - imageIndex 할당 오류")
                return
            }
            print("UserDefaults - imageIndex: \(imageIndex)")
            
            // POST 통신
            WillsonerRegisterServices.shared.postRegisterComplete( subCategoryIndex: subCategoryIndex, experience: experience, keywordIndex: keywordIndex, introduction: introduction, imageIndex: imageIndex, auth_licence: "", auth_media: "", auth_phone: phone, auth_email: "") { registerComplete in
                self.registerComplete = registerComplete
                print(self.registerComplete ?? "")
                print("===============")
                print("헬퍼 등록 통신 성공")
                
                // UserDefault 삭제
                UserDefaults.standard.removeObject(forKey: "categoryIndex")
                UserDefaults.standard.removeObject(forKey: "subCategoryIndex")
                UserDefaults.standard.removeObject(forKey: "experience")
                UserDefaults.standard.removeObject(forKey: "keywordIndex")
                UserDefaults.standard.removeObject(forKey: "introduction")
                UserDefaults.standard.removeObject(forKey: "imageIndex")
                
                self.view.makeToast("윌스너 가입 신청이 완료되었습니다.",
                duration: 2.0,
                position: .bottom,
                 style: ToastStyle())
                
                self.dismiss(animated: true, completion: nil)
            }
        }
        /*
        self.view.makeToast("인증번호를 다시 입력해주세요.",
        duration: 3.0,
        position: .bottom,
         style: ToastStyle())
        */
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // keyboard hide - view tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tap)

        // navi bar right item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icX"), style: .plain, target: self, action: #selector(tappedBarButton(sender:)))
        
        // 버튼 비활성화
        requestButton.isEnabled = false
        completeButton.isEnabled = false
        
        verifyNumberTextField.isEnabled = false
        
        // textfield delegate
        phoneNumberTextField.delegate = self
        verifyNumberTextField.delegate = self
        
        phoneNumberTextField.addTarget(self, action: #selector(phoneNumberChange(_:)), for: .editingChanged)
        verifyNumberTextField.addTarget(self, action: #selector(verifyNumberChange(_:)), for: .editingChanged)
        
        // 로딩중
        self.view.addSubview(self.activityIndicator)
    }
    
    // MARK: - Methods
    @objc func tappedBarButton(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension HelperApplicationPhoneNumberViewController: UITextFieldDelegate {
    // 빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

    // textfield 입력 감지 - 버튼 활성화
    @objc func phoneNumberChange(_ textField: UITextField) {
        updateRequestButton(textField)
        updateCompleteButton(textField)
    }
    
    @objc func verifyNumberChange(_ textField: UITextField) {
        updateCompleteButton(textField)
    }
    
    // 인증 요청 버튼 활성화
    func updateRequestButton(_ textField: UITextField) {
        if textField.text?.count == 11 {
            requestButton.isEnabled = true
            verifyNumberTextField.isEnabled = true
        } else {
            requestButton.isEnabled = false
            verifyNumberTextField.isEnabled = false
        }
    }
    
    // 완료 버튼 활성화
    func updateCompleteButton(_ textField: UITextField) {
        if textField.text?.count == 6 {
            completeButton.isEnabled = true
        } else {
            completeButton.isEnabled = false
        }
    }
}
