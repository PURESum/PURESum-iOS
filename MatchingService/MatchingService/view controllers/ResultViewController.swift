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
    var content: String?
    var predict: Predict?
    
    // MARK: - IBOutlet
    @IBOutlet weak var userTextView: CustomTextView!
    
    @IBOutlet weak var resultTextView: CustomTextView!
    
    @IBOutlet weak var categoryPercentageLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // show navigation bar
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.userTextView.text = content
        
        self.resultTextView.text = predict?.data.predict.text
        // 퍼센트
        if let percent = predict?.data.predict.percent {
            self.categoryPercentageLabel.text = "\(percent)%"
        } else {
            self.categoryPercentageLabel.text = "0%"
        }
        // 카테고리
        if let category = predict?.data.predict.category {
            self.categoryLabel.text = "'\(category)'"
        } else {
            self.categoryLabel.text = "\'--'"
        }
        
    }
    
    // MARK: - Methods
    
}
