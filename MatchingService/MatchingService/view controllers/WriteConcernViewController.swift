//
//  WriteConcernViewController.swift
//  MatchingService
//
//  Created by JHKim on 2020/04/13.
//  Copyright © 2020 zhi. All rights reserved.
//

import UIKit

class WriteConcernViewController: UIViewController {
    
    // MARK: - properties
    let maxCount = 300
    
    var width: CGFloat?
    var height: CGFloat?
    
    // response model
    var predict: Predict?
    
    // MARK: - IBOutlet
    @IBOutlet weak var boxView: UIView!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var countStackView: UIStackView!
    
    @IBOutlet weak var matchButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedMatchButton(_ sender: Any) {
        self.view.endEditing(true)
        
        if textView.text == "" || textView.text == "300자 이내로 작성해 주세요." {
            let toastLabel = UILabel(frame: CGRect(x: view.frame.size.width / 2 - 100, y: view.frame.size.height - 100, width: 200, height: 36))
            toastLabel.backgroundColor = .clear
            toastLabel.textColor = .white
            toastLabel.textAlignment = .center
            view.addSubview(toastLabel)
            
            toastLabel.text = "내용을 입력해 주세요."
            toastLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 16)
            toastLabel.alpha = 1.0
            toastLabel.backgroundColor = .darkGray
            toastLabel.layer.cornerRadius = 18
            toastLabel.clipsToBounds = true
            
            UIView.animate(withDuration: 2.0, animations: {
                toastLabel.alpha = 1.0
            }) { (true) in
                UIView.animate(withDuration: 2.0, animations: {
                    toastLabel.alpha = 0.0
                }) { (true) in
                    UIView.animate(withDuration: 2.0, animations: {
                        toastLabel.alpha = 0.0
                    }) { (true) in
                        DispatchQueue.main.async(execute: {
                            self.dismiss(animated: true, completion: nil)
                        })
                    }
                }
            }
        } else {
            guard let vc: WaitingViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "WaitingViewController") as? WaitingViewController else {
                return
            }
            
            vc.preferredContentSize.width = self.view.bounds.width
            vc.preferredContentSize.height = self.view.bounds.height
            vc.modalPresentationStyle = .overFullScreen
            
            // delegate
            vc.content = textView.text
            vc.searchingDelegate = self
            
            self.present(vc, animated: false)
        }
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // add keyboard notification center
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil) // keyboard will show
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil) // keyboard will hide
        
        // hide navigation bar
        navigationController?.isNavigationBarHidden = true
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // remove keyboard notification center
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // show navigation bar
        navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: - Methods
    // 초기에 textView가 비어있는지 확인
    private func setUpTextView() {
        if textView.text != "300자 이내로 작성해 주세요." {
            updateCharacterCount()
        } else {
            countLabel.text = "0"
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
        } else if textView.text == "" {
            textView.text = "300자 이내로 작성해 주세요."
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

extension WriteConcernViewController: UITextViewDelegate {
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

extension WriteConcernViewController: SearchingDelegate {
    func getMatchResult(result: Predict) {
        print("getMatchResult !")
        
        self.predict = result
        print(String(describing: self.predict))
        guard let vc: ResultViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else {
            return
        }
        
        vc.content = textView.text
        vc.predict = self.predict
        self.show(vc, sender: nil)
    }
}
