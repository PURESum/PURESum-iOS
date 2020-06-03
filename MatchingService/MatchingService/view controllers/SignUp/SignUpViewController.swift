//
//  SignUpViewController.swift
//  MatchingService
//
//  Created by JHKim on 2020/05/28.
//  Copyright © 2020 zhi. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {

    // MARK: - properties
    
    // MARK: - IBOutlet
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var PWTextField: UITextField!
    @IBOutlet weak var checkPWField: UITextField!
    
    @IBOutlet weak var completeButtonItem: UIBarButtonItem!
    
    // MARK: - IBAction
    @IBAction func tappedXButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedCompleteButtonItem(_ sender: Any) {
        
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: - Methods
}
