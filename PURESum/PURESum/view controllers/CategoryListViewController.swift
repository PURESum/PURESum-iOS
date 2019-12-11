//
//  CategoryListViewController.swift
//  PURESum
//
//  Created by JHKim on 2019/12/04.
//  Copyright © 2019 JHKim. All rights reserved.
//

import UIKit

class CategoryListViewController: UIViewController {

    // MARK: - properties
    let cellIdentifier: String = "ListCollectionViewCell"
    var titleString: String?
    
    let titleArray: [String] = ["엑시트", "조커", "82년생 김지영", "가장 보통의 연애", "타이타닉", "곡성"]
    let imageArray: [String] = ["image_1", "image_2", "image_3", "image_4", "image_5", "image_6"]
    
    // MARK: - IBOutlet
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.title = "'\(titleString ?? "")' 카테고리"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // collectionview delegate, datasource
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    // MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextVC: ResultViewController = segue.destination as? ResultViewController else { return }
        guard let cell: ListCollectionViewCell = sender as? ListCollectionViewCell else { return }
        
        nextVC.titleString = cell.label?.text
    }
}

extension CategoryListViewController: UICollectionViewDelegate {
    
}

extension CategoryListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: ListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? ListCollectionViewCell else { return UICollectionViewCell ()}
        cell.imageView.image = UIImage(named: imageArray[indexPath.row])
        cell.label.text = titleArray[indexPath.item]
        return cell
    }
}
extension CategoryListViewController: UICollectionViewDelegateFlowLayout {
    
}
