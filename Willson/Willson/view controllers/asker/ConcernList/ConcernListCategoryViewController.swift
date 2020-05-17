//
//  ConcernListCategoryViewController.swift
//  Willson
//
//  Created by JHKim on 15/09/2019.
//

import UIKit

class ConcernListCategoryViewController: UIViewController {

    // MARK: - properties
    let categoryCellIdentifier: String = "ConcernListCategoryCollectionViewCell"
    
    let categoryArrray: [String] = ["연애", "진로", "일상", "인간관계", "자존감", "기타"]
    let imageNameGrayArray: [String] = ["icHeartEmpty1", "icBook", "icCoffee", "icPeople", "icSprout", "icQuestionMark"]
    let imageNameNavyArray: [String] = ["icHeartNavy", "icBookNavy", "icCoffeeNavy", "icPeopleNavy", "icSproutNavy", "icQuestionMarkNavy"]
    
    // 카테고리 인덱스
    var categoryIndex: Int?
    
    // MARK: - IBOutlet
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func tappedNextButton(_ sender: Any) {
        UserDefaults.standard.set(categoryIndex, forKey: "categoryIndex")
        guard let categoryIndex = UserDefaults.standard.value(forKey: "categoryIndex") else {
            print("UserDefaults - categoryIndex 할당 오류")
            return
        }
        print("categoryIndex: \(categoryIndex)")
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 처음에 버튼 비활성화
        nextButton.isEnabled = false

        // collection view delegate, datasource
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        categoryCollectionView.isMultipleTouchEnabled = false
        categoryCollectionView.isExclusiveTouch = true
    }
    
    // MARK: - Methods
}

// MARK: - collection view delegate
extension ConcernListCategoryViewController: UICollectionViewDelegate {
    
    // did select item
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ConcernListCategoryCollectionViewCell else {
            print("didSelectedItemAt - cell 할당 오류")
            return
        }
        if cell.isSelected {
            cell.label.textColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
            cell.bgView.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
            cell.imageView.image = UIImage(named: imageNameNavyArray[indexPath.item])
            nextButton.isEnabled = true
            categoryIndex = indexPath.item + 1
            print("==========")
            guard let index = categoryIndex else {
                print("category index 할당 오류")
                return 
            }
            print("categoryIndex: \(index)")
            
            
        } else {
            cell.label.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            cell.bgView.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            cell.imageView.image = UIImage(named: imageNameGrayArray[indexPath.item])
            nextButton.isEnabled = false
        }
        
    }
    
    // did deselect item
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
        guard let cell = collectionView.cellForItem(at: indexPath) as? ConcernListCategoryCollectionViewCell else {
            print("didSelectedItemAt - cell 할당 오류")
            return
        }
        if cell.isSelected {
            cell.label.textColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
            cell.bgView.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
            cell.imageView.image = UIImage(named: imageNameNavyArray[indexPath.item])
            nextButton.isEnabled = true
            categoryIndex = indexPath.item + 1
            print("==========")
            guard let index = categoryIndex else {
                print("category index 할당 오류")
                return
            }
            print("categoryIndex: \(index)")
            
            
        } else {
            cell.label.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            cell.bgView.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            cell.imageView.image = UIImage(named: imageNameGrayArray[indexPath.item])
            nextButton.isEnabled = false
        }
    }
}

// MARK: - collection view datasource
extension ConcernListCategoryViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryArrray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ConcernListCategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellIdentifier, for: indexPath) as? ConcernListCategoryCollectionViewCell else { return UICollectionViewCell() }
        
        cell.imageView.image = UIImage(named: imageNameGrayArray[indexPath.item])
        cell.label.text = categoryArrray[indexPath.item]
        cell.imageView.layer.masksToBounds = false
        cell.label.layer.masksToBounds = false
        cell.layer.masksToBounds = false
        
        return cell
    }
}

extension ConcernListCategoryViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (UIScreen.main.bounds.width - 74) / 3
        return CGSize(width: size, height: size)
    }
}
