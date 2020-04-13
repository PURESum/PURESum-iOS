//
//  WaitingViewController.swift
//  MatchingService
//
//  Created by JHKim on 2020/04/13.
//  Copyright © 2020 zhi. All rights reserved.
//

import UIKit

protocol SearchingDelegate: class {
    func getMatchResult(result: String)
}

class WaitingViewController: UIViewController {
    
    // MARK: - properties
    // 로딩중 인디케이터
    lazy var activityIndicator: UIActivityIndicatorView = {
        // Create an indicator.
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = .black
            // Also show the indicator even when the animation is stopped.
            activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.large
        // Start animation.
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    // dismiss delegate
    var searchingDelegate: SearchingDelegate?
    
    // MARK: - IBOutlet
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - IBAction
    @IBOutlet weak var cancelButton: UIButton!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // 로딩중
        self.view.addSubview(self.activityIndicator)
        // 로딩중 시작
        self.activityIndicator.startAnimating()
        
        // finish searching
        finishSearching()
    }
    
    // MARK: - Methods
    func finishSearching() {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + .seconds(2)) {
            self.searchingDelegate?.getMatchResult(result: "결과값 입니다. :)")
            self.dismiss(animated: false, completion: nil)
        }
    }
}
