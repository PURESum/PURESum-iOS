//
//  WaitingViewController.swift
//  MatchingService
//
//  Created by JHKim on 2020/04/13.
//  Copyright © 2020 zhi. All rights reserved.
//

import UIKit

protocol SearchingDelegate: class {
    func getMatchResult(result: Predict)
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
    
    // 사용자의 글
    var content: String?
    
    // predict response model
    var predict: Predict?
    
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
        guard let content: String = self.content else {
            print("content 할당 오류")
            return
        }
        PredictServices.shared.postPredict(content: content) { predict in
            
            self.predict = predict
            print("========")
            print("POST /predict 통신 성공")
            print(String(describing: self.predict))
            
            self.searchingDelegate?.getMatchResult(result: predict)
            self.dismiss(animated: false, completion: nil)
        }
    }
}
