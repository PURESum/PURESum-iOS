//
//  AskerPayMethodViewController.swift
//  Willson
//
//  Created by JHKim on 31/10/2019.
//

import UIKit

class AskerPayMethodViewController: UIViewController {

    // MARK: - properties
    var tickets: [Ticket]?
    var ticketIndex: Int?
    
    // 고민 신청 완료 response model
    var concernIndex: Int?
    
    // 결제 완료 resposne model
    var payComplete: AskerPayComplete?
    
    // MARK: - IBOutlet
    @IBOutlet weak var ticketTypeLabel: UILabel!
    @IBOutlet weak var ticketPriceLabel: UILabel!
    
    @IBOutlet weak var paymentButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedPaymentButton(_ sender: Any) {
        guard let concernIndex: Int = self.concernIndex else {
            print("concernIndex 할당 오류")
            return
        }
        guard let ticketIndex: Int = self.ticketIndex else {
            print("ticketIndex 할당 오류")
            return
        }
        
        AskerPayServices.shared.postPay(concernIndex: concernIndex, ticketIndex: ticketIndex) { payComplete in
            self.payComplete = payComplete
            print("================")
            print("최종결제 완료 !")
            
            print("\(String(describing: self.payComplete))")
            
            // 통신 완료 후 삭제
            UserDefaults.standard.removeObject(forKey: "subCategoryIndex")
            UserDefaults.standard.removeObject(forKey: "feelingIndex")
            UserDefaults.standard.removeObject(forKey: "content")
            UserDefaults.standard.removeObject(forKey: "willGender")
            UserDefaults.standard.removeObject(forKey: "personalityIndex")
            UserDefaults.standard.removeObject(forKey: "directionIndex")
            UserDefaults.standard.removeObject(forKey: "type")
            
            // 화면 이동
            let tabbarStoryboard = UIStoryboard(name: "AskerTabbar", bundle: nil)
            guard let tabBarController: UITabBarController = tabbarStoryboard.instantiateViewController(withIdentifier: "AskerTabbarController") as? UITabBarController else { return }
            
            tabBarController.selectedIndex = 1
            
            let navi = UIStoryboard(name: "AskerTabbar", bundle: nil).instantiateViewController(withIdentifier: "AskerApplyConcernNavi")
            
            tabBarController.viewControllers?[1] = navi
            tabBarController.tabBar.items?[1].image = UIImage(named: "icTabListGray")
            tabBarController.tabBar.items?[1].selectedImage = UIImage(named: "icTabListNavy")
            tabBarController.tabBar.items?[1].title = "상담신청"
            
            tabBarController.modalPresentationStyle = .fullScreen
            self.present(tabBarController, animated: true)
        }
    }
    
    // MARK: life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // 화면 setup
        setUp()
    }
    
    // MARK: - Methods
    func setUp() {
        if let idx = ticketIndex {
            ticketTypeLabel.text = tickets?[idx - 1].type
            ticketPriceLabel.text = tickets?[idx - 1].amount
            
            self.view.reloadInputViews()
            paymentButton.isEnabled = true
        } else {
            paymentButton.isEnabled = false
        }
        
    }
}
