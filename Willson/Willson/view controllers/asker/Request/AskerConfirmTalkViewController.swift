//
//  AskerConfirmTalkViewController.swift
//  Willson
//
//  Created by JHKim on 11/10/2019.
//

import UIKit

class AskerConfirmTalkViewController: UIViewController {

    // MARK: - properties
    // 윌스너 선택 (최종 수락) response model
    var matchSuccessData: MatchSuccessData?
    
    // MARK: - IBOutlet
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var ageAndGenderLabel: UILabel!
    @IBOutlet weak var personalitiesLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: UILabel!
    
    @IBOutlet weak var startChatButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        let tabbarStoryboard = UIStoryboard(name: "AskerTabbar", bundle: nil)
        guard let tabBarController: UITabBarController = tabbarStoryboard.instantiateViewController(withIdentifier: "AskerTabbarController") as? UITabBarController else { return }
        
        tabBarController.selectedIndex = 1
        
        let navi = UIStoryboard(name: "AskerTabbar", bundle: nil).instantiateViewController(withIdentifier: "AskerRequestNavi")
        
        tabBarController.viewControllers?[1] = navi
        tabBarController.tabBar.items?[1].image = UIImage(named: "icTabRequestGray")
        tabBarController.tabBar.items?[1].selectedImage = UIImage(named: "icTabRequestNavy")
        tabBarController.tabBar.items?[1].title = "고민신청"
        
        
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
    }
    
    @IBAction func tappedStartChatButton(_ sender: Any) {
        let tabbarStoryboard = UIStoryboard(name: "AskerTabbar", bundle: nil)
        guard let tabBarController: UITabBarController = tabbarStoryboard.instantiateViewController(withIdentifier: "AskerTabbarController") as? UITabBarController else { return }
        
        tabBarController.selectedIndex = 2
        
        let navi = UIStoryboard(name: "AskerTabbar", bundle: nil).instantiateViewController(withIdentifier: "AskerChatNavi")
        
        tabBarController.viewControllers?[2] = navi
        tabBarController.tabBar.items?[2].image = UIImage(named: "icTabChatGray")
        tabBarController.tabBar.items?[2].selectedImage = UIImage(named: "icTabChatNavy")
        tabBarController.tabBar.items?[2].title = "채팅"
        
        
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
