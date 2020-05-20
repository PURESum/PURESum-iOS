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
    
    var willsonerDetailMatch: WillsonerDetailMatch?
    
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

        // set up
        setUp()
    }
    
    // MARK: - Methods
    private func setUp() {
        // 이미지
        if let urlString = willsonerDetailMatch?.willsoner.image?.pic {
            let url = URL(string: urlString)
            imageView.kf.setImage(with: url)
        } else {
            print("setUpViews: urlString 할당 오류")
            imageView.image = UIImage()
        }
        
        // 닉네임
        if let nickname = willsonerDetailMatch?.willsoner.asker.nickname {
            nicknameLabel.text = nickname
        } else {
            print("setUpViews: nickname 할당 오류")
            nicknameLabel.text = ""
        }
        
        // 나이 / 성별
        if let age = willsonerDetailMatch?.willsoner.asker.age {
            if let gender = willsonerDetailMatch?.willsoner.asker.gender {
                ageAndGenderLabel.text = "\(age) / \(gender)"
            } else {
                print("setUpViews: 성별 할당 오류")
                ageAndGenderLabel.text = "\(age)"
            }
        } else {
            print("setUpViews: 나이 할당 오류")
            ageAndGenderLabel.text = ""
        }
        
        // 성격
        if let keywords = willsonerDetailMatch?.willsoner.keywords {
            var keywordString = ""
            for keyword in keywords {
                keywordString = "#\(keyword.name) "
            }
            personalitiesLabel.text = keywordString
        } else {
            print("setUpViews: 키워드 할당 오류")
            personalitiesLabel.text = ""
        }
        
        // 카테고리
        if let category = willsonerDetailMatch?.willsoner.subcategories[0].category.name {
            categoryLabel.text = category
        } else {
            print("setUpViews: 카테고리 할당 오류")
            categoryLabel.text = ""
        }
    }
    

}
