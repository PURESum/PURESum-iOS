//
//  ConcernWriteViewController.swift
//  Willson
//
//  Created by JHKim on 2020/05/18.
//

import UIKit

class ConcernWriteViewController: UIViewController {

    // MARK: - properties
    let maxCount = 300
    
    var width: CGFloat?
    var height: CGFloat?
    
    // MARK: - IBOutlet
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        self.view.endEditing(true)
        
        guard let vc: ConcernListAgreementViewController = UIStoryboard(name: "AskerConcernList", bundle: nil).instantiateViewController(withIdentifier: "ConcernListAgreementViewController") as? ConcernListAgreementViewController else {
            return
        }
        
        self.navigationController?.show(vc, sender: nil)
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add keyboard notification center
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil) // keyboard will show
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil) // keyboard will hide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 빈 화면 탭했을 때 키보드 내리기
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        self.view.addGestureRecognizer(tap)
        
        // textView 글자수 설정
        setUpTextView()
        
        // textView delegate
        textView.delegate = self
        
        // width, height 저장
        width = self.view.bounds.width
        height = self.view.bounds.height
        
        // 초기에 버튼 비활성화
        nextButton.isEnabled = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // remove keyboard notification center
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Methods
    // 초기에 textView가 비어있는지 확인
    private func setUpTextView() {
        if textView.text != "300자 이내로 작성해 주세요." {
            updateCharacterCount()
            textView.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        } else {
            countLabel.text = "0"
            textView.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        }
    }
    
    // textView 글자수 반영하기
    private func updateCharacterCount() {
        let count = textView.text.count
        countLabel.text = "\(count)"
    }
    
    // textView place holder 설정하기
    private func setPlaceHolder() {
        if textView.text == "300자 이내로 작성해 주세요." {
            textView.text = ""
            textView.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        } else if textView.text == "" {
            textView.text = "300자 이내로 작성해 주세요."
            textView.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        }
    }
    
    // 다음 버튼 활성화 / 비활성화
    private func checkAllFilled() {
        if countLabel.text == "0" {
            nextButton.isEnabled = false
        } else {
            nextButton.isEnabled = true
        }
    }
    
    // 빈 화면 탭했을 때 키보드 내리기
    @objc private func viewDidTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // 키보드 올라 왔을 때 호출되는 함수
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.size == CGSize(width: width!, height: height!) {
                self.view.frame.size = CGSize(width: self.view.bounds.width, height: self.view.bounds.height - keyboardSize.height)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    // 키보드 내려갈 때 호출되는 함수
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.size != CGSize(width: width!, height: height!) {
                self.view.frame.size = CGSize(width: self.view.bounds.width, height: self.view.bounds.height + keyboardSize.height)
                self.view.layoutIfNeeded()
            }
        }
    }
}

// MARK: - UITextViewDelegate
extension ConcernWriteViewController: UITextViewDelegate {
    // textView 수정이 시작되었을 때
    func textViewDidBeginEditing(_ textView: UITextView) {
        setPlaceHolder()
    }
    
    // textView 수정이 끝났을 때
    func textViewDidEndEditing(_ textView: UITextView) {
        setPlaceHolder()
    }
    
    // textView가 수정되었을 때
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount()
        checkAllFilled()
    }
    
    // 300자가 넘어갔을 때 제어하기
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if let string = textView.text {
            let newlength = string.count + text.count - range.length
            return newlength <= maxCount
        } else {
            return false
        }
    }
}
