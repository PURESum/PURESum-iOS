//
//  HelperRequestDefaultViewController.swift
//  Willson
//
//  Created by JHKim on 11/10/2019.
//

/*
import UIKit

class HelperRequestDefaultViewController: UIViewController {
    
    // MARK: - properties

    // MARK: - IBOutlet
    @IBOutlet weak var modifyProfileButtonView: UIView!
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        let modifyProfileButtonGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedModifyProfileButtonView(_:)))
        modifyProfileButtonView.addGestureRecognizer(modifyProfileButtonGesture)
    }

    // MARK: - Methods
    @objc func tappedModifyProfileButtonView(_ : UITapGestureRecognizer) {
        let tabbarStoryboard = UIStoryboard(name: "HelperTabbar", bundle: nil)
        guard let tabBarController: UITabBarController = tabbarStoryboard.instantiateViewController(withIdentifier: "HelperTabbarController") as? UITabBarController else { return }
        
        tabBarController.selectedIndex = 1
        
        let navi = UIStoryboard(name: "HelperTabbar", bundle: nil).instantiateViewController(withIdentifier: "HelperRequestNavi")
        
        tabBarController.viewControllers?[1] = navi
        tabBarController.tabBar.items?[1].image = UIImage(named: "icTabListGray")
        tabBarController.tabBar.items?[1].selectedImage = UIImage(named: "icTabListNavy")
        tabBarController.tabBar.items?[1].title = "상담신청"
        
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
    }
}
*/
