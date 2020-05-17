//
//  AskerSearchingWillsonerViewController.swift
//  Willson
//
//  Created by JHKim on 2020/05/12.
//

import UIKit

class AskerSearchingWillsonerViewController: UIViewController {

    // MARK: - properties
    var remainingSeconds: Int?
    var timer = Timer()
    
    // MARK: - IBOutlet
    @IBOutlet weak var xButton: UIButton!
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var cancelRequestButton: CustomButton!
    
    // MARK: - IBAction
    @IBAction func tappedXButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func tappedCancelRequestButton(_ sender: Any) {
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeLimit), userInfo: nil, repeats: true)
    }
    
    // MARK: - Methods
    // timer
    @objc private func timeLimit() {
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
    
    private func timeLimitStop() {
        timer.invalidate()
        
        self.navigationController?.popViewController(animated: true)
    }
}
