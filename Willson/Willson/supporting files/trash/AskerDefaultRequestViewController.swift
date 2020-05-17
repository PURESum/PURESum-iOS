//
//  AskerDefaultRequestViewController.swift
//  Willson
//
//  Created by JHKim on 15/09/2019.
//

/*
import UIKit

class AskerDefaultRequestViewController: UIViewController {

    // MARK: - IBOutlet
    @IBOutlet weak var applyButtonView: UIView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar hide
        navigationController?.setNavigationBarHidden(true, animated: true)

        // apply button action
        let applyButtonViewTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedApplyButtonView(_:)))
        applyButtonView.addGestureRecognizer(applyButtonViewTapGesture)
    }

    // MARK: - Methods
    @objc func tappedApplyButtonView(_ gesture: UITapGestureRecognizer) {
        let tabbarStoryboard = UIStoryboard(name: "AskerTabbar", bundle: nil)
        guard let tabBarController: UITabBarController = tabbarStoryboard.instantiateViewController(withIdentifier: "AskerTabbarController") as? UITabBarController else { return }
        
        tabBarController.selectedIndex = 1
        
        let navi = UIStoryboard(name: "AskerTabbar", bundle: nil).instantiateViewController(withIdentifier: "AskerRequestConcernListNavi")
        
        tabBarController.viewControllers?[1] = navi
        tabBarController.tabBar.items?[1].image = UIImage(named: "ic_tab_list_gray")
        tabBarController.tabBar.items?[1].selectedImage = UIImage(named: "ic_tab_list_navy")
        tabBarController.tabBar.items?[1].title = "상담신청"
        
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
    }
}
*/
