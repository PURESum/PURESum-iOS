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
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        // add keyboard notification center
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil) // keyboard will show
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil) // keyboard will hide
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 빈 화면 탭했을 때 키보드 내리기
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        self.view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // remove keyboard notification center
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Methods
    // 빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // 키보드 올라 왔을 때 호출되는 함수
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.size = CGSize(width: self.view.bounds.width, height: self.view.bounds.height - keyboardSize.height)
            self.view.layoutIfNeeded()
        }
    }
    
    // 키보드 내려갈 때 호출되는 함수
    @objc func keyboardWillHide(_ notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.view.frame.size = CGSize(width: self.view.bounds.width, height: self.view.bounds.height + keyboardSize.height)
            self.view.layoutIfNeeded()
        }
    }
}
