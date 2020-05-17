//
//  HelperHomeViewController.swift
//  Willson
//
//  Created by JHKim on 2019/11/03.
//

import UIKit

class HelperHomeViewController: UIViewController {

    // MARK: - properties
    
    // MARK: - IBOutlet
    @IBOutlet weak var HelperApplyButtonView: UIView!
    
    // MARK: - IBAction
    @IBAction func tappedGoToAsker(_ sender: Any) {
        guard let vc = UIStoryboard(name: "AskerTabbar", bundle: nil).instantiateViewController(withIdentifier: "AskerTabbarController") as? UITabBarController else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // helper Apply Button View Action
        let helperApplyTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedHelperApplyButtonView(_:)))
        HelperApplyButtonView.addGestureRecognizer(helperApplyTapGesture)
    }
    
    // MARK: - Methods
    @objc func tappedHelperApplyButtonView(_ tapGesture: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "HelperApplication", bundle: nil).instantiateViewController(withIdentifier: "HelperApplicationNavi")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

}

extension HelperHomeViewController: UICollectionViewDelegate {
    
}

extension HelperHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
    
    
}

extension HelperHomeViewController: UICollectionViewDelegateFlowLayout {
    
}
