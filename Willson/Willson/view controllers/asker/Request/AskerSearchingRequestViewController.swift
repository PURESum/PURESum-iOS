//
//  AskerSearchingRequestViewController.swift
//  Willson
//
//  Created by JHKim on 15/09/2019.
//

import UIKit

class AskerSearchingRequestViewController: UIViewController {

    // MARK: - properties
    var remainingSeconds: Int?
    var timer = Timer()
    
    var concernIndex: Int?
    
    // MARK: - IBOutlet
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // timer
//        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeLimit), userInfo: nil, repeats: true)
    }

    // MARK: - Methods
    // timer
    @objc func timeLimit() {
        let timerFormatter = DateFormatter()
        
        if remainingSeconds! > 0 {
            remainingSeconds! -= 1
            timeLabel.text = "\(remainingSeconds! / 60):\(remainingSeconds! % 60)"
            timerFormatter.dateFormat = "mm:ss"
            if let formattime = timerFormatter.date(from:timeLabel.text ?? "") {
                timeLabel.text = timerFormatter.string(from: formattime)
            }
        } else {
            timeLimitStop()
        }
    }
    
    func timeLimitStop() {
        timer.invalidate()
        
        self.navigationController?.popViewController(animated: true)
    }
}
