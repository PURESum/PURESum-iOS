//
//  SignUpSexAndAgeViewController.swift
//  Willson
//
//  Created by JHKim on 2019/12/24.
//

import UIKit

class SignUpSexAndAgeViewController: UIViewController {
    
    // MARK: - properties
    let ageArray: [String] = ["2001", "2000", "1999", "1998", "1997", "1996", "1995", "1994", "1993", "1992", "1991", "1990"]
    
    var keyboardShown: Bool = false // 키보드 상태 확인
    var originY: CGFloat? // 오브젝트의 기본 위치
    
    /*
    // 이전 화면에서 값 받아오기
    var email: String?
    var password: String?
    */
    
    // 성별
    var gender: String?
    
    var age: String?
    
    // MARK: - IBOutlet
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    
    @IBOutlet weak var ageTextField: UITextField!
    
    @IBOutlet weak var checkButton: CustomButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        UserDefaults.standard.set(gender, forKey: "gender")
        if let age = age {
            UserDefaults.standard.set(age, forKey: "age")
        }
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /*
        // add keyboard notification center
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillHideNotification, object: nil) // keyboard will show
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil) // keyboard will hide
        */
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 처음에 버튼 비활성화
        checkButton.isEnabled = false
        
        /*
        // keyboard hide - view tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tap)
        */
        
        /*
        let pickerView = UIPickerView()
        
        // picker view delegate
        pickerView.delegate = self
        pickerView.dataSource = self
        */
        
        // textfield delegate
        ageTextField.delegate = self
        
        /*
        // textfield input view를 pickerview로 설정
        ageTextField.inputView = pickerView
        
        // textfield 입력 감지 - 버튼 활성화
        ageTextField.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
        */
        
        // tapped ageTextField
        ageTextField.addTarget(self, action: #selector(tappedAgeTextField(_:)), for: .editingDidBegin)
        
        // button add target
        maleButton.addTarget(self, action: #selector(myButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        femaleButton.addTarget(self, action: #selector(myButtonTapped(_:)), for: UIControl.Event.touchUpInside)
    }
    
    // MARK: - Methods
    func checkCanActiveButton() {
        if ageTextField.hasText && (maleButton.tag + femaleButton.tag) == 1 {
            checkButton.isEnabled = true
        } else { checkButton.isEnabled = false }
    }
    
    @objc func myButtonTapped(_ button: UIButton){
        if button == femaleButton {
            if button.tag == 1 {
                button.tag = 0
                button.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), for: .normal)
                button.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            } else {
                if maleButton.tag == 1 {
                    maleButton.tag = 0
                    maleButton.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), for: .normal)
                    maleButton.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
                }
                button.tag = 1
                button.backgroundColor = .clear
                button.setTitleColor(#colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1), for: .normal)
                button.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
                gender = "F"
            }
        } else if button == maleButton {
            if button.tag == 1 {
                button.tag = 0
                button.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), for: .normal)
                button.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            } else {
                if femaleButton.tag == 1 {
                    femaleButton.tag = 0
                    femaleButton.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), for: .normal)
                    femaleButton.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
                }
                button.tag = 1
                button.backgroundColor = .clear
                button.setTitleColor(#colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1), for: .normal)
                button.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
                gender = "M"
            }
        }
        checkCanActiveButton()
    }
    
    // tapped ageTextField
    @objc func tappedAgeTextField(_ textField: UITextField) {
        textField.resignFirstResponder()
        
        guard let vc: SignUpAgeViewController = UIStoryboard(name: "SignUp", bundle: nil).instantiateViewController(withIdentifier: "SignUpAgeViewController") as? SignUpAgeViewController else {
            print("tapped age textField: SignUpAgeViewController 할당 오류")
            return
        }
        
        // dismiss delegate
        vc.selectedAgeDelegate = self
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
}

/*
extension SignUpSexAndAgeViewController: SendToSexAndAgeDelegate {
    func sendData(email: String, password: String) {
        self.email = email
        self.password = password
    }
}
*/

// MARK: - SelectAgeDelegate
extension SignUpSexAndAgeViewController: SelectAgeDelegate {
    func didSelectedAge(age: String?) {
        print("SelectedAgeDelegate: didSelectedAge 호출 !")
        if let age = age {
            self.age = age
            self.ageTextField.text = "\(age)년생"
            self.loadViewIfNeeded()
        }
        checkCanActiveButton()
    }
}

// MARK: - UITextFieldDelegate
extension SignUpSexAndAgeViewController: UITextFieldDelegate {
    
    /*
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
        checkCanActiveButton()
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkCanActiveButton()
    }
     */
    
    /*
    // 키보드 올라 왔을 때 호출되는 함수
    @objc func keyboardWillShow(_ sender: Notification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
          let keybaordRectangle = keyboardFrame.cgRectValue
          let keyboardHeight = keybaordRectangle.height
          ageTextField.frame.origin.y -= keyboardHeight
        }
    }
    
    // 키보드 내려갈 때 호출되는 함수
    @objc func keyboardWillHide(_ sender: Notification) {
        if let keyboardFrame: NSValue = sender.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
          let keybaordRectangle = keyboardFrame.cgRectValue
          let keyboardHeight = keybaordRectangle.height
          ageTextField.frame.origin.y += keyboardHeight
        }
    }
    */
}

/*
extension SignUpSexAndAgeViewController: UIPickerViewDelegate {
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        ageTextField.text = ageArray[row]
    }
    
}

extension SignUpSexAndAgeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageArray.count
    }
    
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return ageArray[row]
    }
}
*/
