//
//  ResultViewController.swift
//  MatchingService
//
//  Created by JHKim on 2020/04/13.
//  Copyright © 2020 zhi. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    // MARK: - properties
    var result: String?
    
    // MARK: - IBOutlet
    @IBOutlet weak var textView: CustomTextView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // show navigation bar
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.textView.text = result
    }
    
    // MARK: - Methods
    
}
