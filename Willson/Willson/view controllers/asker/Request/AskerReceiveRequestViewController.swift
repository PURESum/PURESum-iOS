//
//  AskerReceiveRequestViewController.swift
//  Willson
//
//  Created by JHKim on 06/10/2019.
//

import UIKit

class AskerReceiveRequestViewController: UIViewController {

    // MARK: - properties
    let requestCellIdentifier: String = "RequestListCollectionViewCell"
    
    // MARK: - IBOutlet
    @IBOutlet weak var requestListCollectionView: UICollectionView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // 탭바 숨김 해제 처리
        self.tabBarController?.tabBar.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // collection view delegate, datasource
        requestListCollectionView.delegate = self
        requestListCollectionView.dataSource = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
}

extension AskerReceiveRequestViewController: UICollectionViewDelegate {
    
}

extension AskerReceiveRequestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: RequestListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: requestCellIdentifier, for: indexPath) as? RequestListCollectionViewCell else { return UICollectionViewCell() }
        
        return cell
    }
    
    
}

extension AskerReceiveRequestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: 308)
    }
}
