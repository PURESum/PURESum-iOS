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
        self.categoryPercentageLabel.text = "\(String(describing: predict?.data.predict.percent))%"
        self.categoryLabel.text = "\'\(String(describing: predict?.data.predict.category))'"
    }
    
    // MARK: - Methods
    
}
