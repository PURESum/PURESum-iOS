//
//  MainViewController.swift
//  PURESum
//
//  Created by JHKim on 2019/12/04.
//  Copyright © 2019 JHKim. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    // MARK: - properties
    let cellIdentifier: String = "categoryCollectionViewCell"
    
    let categoryArray: [String] = ["MOVIE", "RESTAURANT", "PRODUCT"]
    
    // MARK: - IBOutlet
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // collection view delegate, datasource
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
    }

    // MARK: - Methods
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let nextVC: CategoryListViewController = segue.destination as? CategoryListViewController else { return }
        guard let cell: categoryCollectionViewCell = sender as? categoryCollectionViewCell else { return }
        
        nextVC.titleString = cell.label?.text
    }
}

extension MainViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}

extension MainViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: categoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? categoryCollectionViewCell else { return UICollectionViewCell() }
        
        switch indexPath.item {
        case 0:
            cell.imageView.image = #imageLiteral(resourceName: "icon_movie.jpeg")
            cell.label.text = categoryArray[indexPath.item]
        case 1:
            cell.imageView.image = #imageLiteral(resourceName: "icon_food.jpeg")
            cell.label.text = categoryArray[indexPath.item]
        case 2:
            cell.imageView.image = #imageLiteral(resourceName: "icon_product.jpeg")
            cell.label.text = categoryArray[indexPath.item]
        default: break
        }
        return cell
    }
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150, height: 150)
    }
}
