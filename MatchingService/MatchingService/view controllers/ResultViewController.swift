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
        
        // collectionView
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.minimumLineSpacing = 0
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.decelerationRate = .fast
        
        collectionView.reloadData()
        
        self.userTextView.text = content
        
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

// MARK: - UIScrollViewDelegate
extension ResultViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == collectionView {
            // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
            let cellWidth: CGFloat = UIScreen.main.bounds.width - 80
            let insetX = (UIScreen.main.bounds.width - cellWidth) / 2.0
            
            // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
            // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
            let page: CGFloat = targetContentOffset.pointee.x / cellWidth
            let roundedPage = round(page)
            
            targetContentOffset.pointee = CGPoint(x: roundedPage * cellWidth - insetX + 10, y: -scrollView.contentInset.top)
        }
    }
}


// MARK: - UICollectionViewDelegate
extension ResultViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension ResultViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = predict?.data.predict.counselor.count {
            return count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: MatchCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? MatchCollectionViewCell else {
            print("collectionView cell 할당 오류")
            return UICollectionViewCell()
        }
        
        // index
        if let index = predict?.data.predict.counselor[indexPath.item].index {
            cell.indexLabel.text = "\(index)번 상담사"
        } else {
            cell.indexLabel.text = "0번 상담사"
        }
        
        // category
        if let category = predict?.data.predict.counselor[indexPath.item].category {
            cell.categoryLabel.text = category
        } else {
            cell.categoryLabel.text = ""
        }
        
        // text
        if let text = predict?.data.predict.counselor[indexPath.item].data {
            cell.textView.text = text
        } else {
            cell.textView.text = ""
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension ResultViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 80, height: 300)
    }
}
