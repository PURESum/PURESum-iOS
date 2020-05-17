//
//  FindPasswordViewController.swift
//  Willson
//
//  Created by JHKim on 2020/01/19.
//

import UIKit

class FindPasswordViewController: UIViewController {

    // MARK: - properties
    
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var checkButton: CustomButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedCheckButton(_ sender: Any) {
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // keyboard hide - view tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tap)
        
        // 처음에 버튼 비활성화
        checkButton.isEnabled = false
    }
    
    // MARK: - Methods
    //빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}
