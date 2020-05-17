//
//  AskerChatSelectImageViewController.swift
//  Willson
//
//  Created by JHKim on 2020/02/27.
//

import UIKit
import Kingfisher

protocol AskerChatReviewDelegate: class {
    func didselectedImage(reviewImageData: ImageData)
}

class AskerChatSelectImageViewController: UIViewController {

    // MARK: - properties
    let cellIdentifier: String = "ChatReviewSelectCollectionViewCell"
    
    // 리뷰 이미지
    var reviewImage: AskerReviewImage?
    var reviewImageData: [ImageData]?
    
    // dismiss delegate
    var askerChatReviewDelegate: AskerChatReviewDelegate?
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // collectionView delegate, dataSource
        let collectionViewLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        collectionViewLayout.minimumLineSpacing = 0
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.decelerationRate = .fast
        
        collectionView.isMultipleTouchEnabled = false
        collectionView.isExclusiveTouch = true

        // GET 통신
        getReviewImage()
        
        // model present delegate
//        self.navigationController?.presentationController?.delegate = self
    }

    // MARK: - Methods
    // GET 통신
    func getReviewImage() {
        ChatServices.shared.getAskerReviewImage { reviewImage in
            self.reviewImage = reviewImage
            self.reviewImageData = self.reviewImage?.data
            print("===================")
            print("리뷰 - 이미지 선택 GET 통신 성공")
            
            self.collectionView.reloadData()
        }
    }
}

// MARK: - UIScrollViewDelegate
extension AskerChatSelectImageViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == collectionView {
            // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
            let cellWidth: CGFloat = UIScreen.main.bounds.width - 96
            let insetX = (UIScreen.main.bounds.width - cellWidth) / 2.0
            
            // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
            // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
            let page: CGFloat = targetContentOffset.pointee.x / cellWidth
            let roundedPage = round(page)
            
            targetContentOffset.pointee = CGPoint(x: roundedPage * cellWidth + insetX - 39, y: -scrollView.contentInset.top)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension AskerChatSelectImageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("didSelectItemAt: \(indexPath.item)")
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ChatReviewSelectCollectionViewCell else {
            print("didSelecteItemAt - cell 할당 오류")
            return
        }
        if cell.isSelected {
            cell.selectButton.isEnabled = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                guard let reviewImageData = self.reviewImageData?[indexPath.item] else {
                    print("didSelectItemAt: reviewImageData 할당 오류")
                    return
                }
                self.askerChatReviewDelegate?.didselectedImage(reviewImageData: reviewImageData)
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            cell.selectButton.isEnabled = false
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AskerChatSelectImageViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = reviewImageData?.count else {
            print("numbeOfItemsInSection: reviewImageData.count 할당 오류")
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ChatReviewSelectCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ChatReviewSelectCollectionViewCell else {
            print("cellForRowAt: ChatReviewSelectCollectionViewCell 할당 오류")
            return UICollectionViewCell()
        }
        
        // 이미지
        guard let urlString = reviewImageData?[indexPath.item].pic else {
            print("cellForItemAt: urlString 할당 오류")
            return UICollectionViewCell()
        }
        let url = URL(string: urlString)
        cell.imageView.kf.setImage(with: url)
        
        // 타입
        guard let type = reviewImageData?[indexPath.item].name else {
            print("cellForItemAt: type 할당 오류")
            return UICollectionViewCell()
        }
        cell.typeLabel.text = type
        
        // 내용
        guard let content = reviewImageData?[indexPath.item].detail else {
            print("cellForItemAt: content 할당 오류")
            return UICollectionViewCell()
        }
        cell.contentLabel.numberOfLines = 2
        cell.contentLabel.text = content
        
        // 버튼
        cell.selectButton.isEnabled = false
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AskerChatSelectImageViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width - 96, height: 487)
    }
}
