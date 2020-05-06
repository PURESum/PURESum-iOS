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
    
    // cell identifier
    let cellIdentifier: String = "MatchCollectionViewCell"
    
    // MARK: - IBOutlet
    @IBOutlet weak var userTextView: CustomTextView!
    
    @IBOutlet weak var resultTextView: CustomTextView!
    
    @IBOutlet weak var categoryPercentageLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
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
        
        // collectionView
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        icollectionView.minimumLineSpacing = 0
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = .fast
        
    }
    
    // MARK: - Methods
    
}

extension ResultViewController: UICollectionViewDelegate {
    
}

extension ResultViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MatchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MatchCollectionViewCell else {
            print("collectionView cell 할당 오류")
            return
        }
        
        return cell
    }
    
    
}

extension ResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 300)
    }
}
