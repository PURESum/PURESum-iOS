//
//  ResultViewController.swift
//  PURESum
//
//  Created by JHKim on 2019/12/04.
//  Copyright © 2019 JHKim. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {

    // MARK: - properties
    var titleString: String?
    
    // MARK: - IBOutlet
    @IBOutlet weak var wordcloudImageView: UIImageView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "'\(titleString ?? "")' 분석 결과"
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    // MARK: Methods

}
