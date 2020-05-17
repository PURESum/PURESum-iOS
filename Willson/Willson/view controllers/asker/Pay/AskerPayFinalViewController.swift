//
//  AskerPayFinalViewController.swift
//  Willson
//
//  Created by JHKim on 2020/05/12.
//

import UIKit

class AskerPayFinalViewController: UIViewController {

    // MARK: - properties
    var tickets: [Ticket]?
    var ticketIndex: Int?
    
    // 고민 신청 완료 response model
    var concernIndex: Int?
    
    // 결제 완료 resposne model
    var pay3: AskerPay3?
    var payComplete: AskerPayComplete?
    
    // MARK: - IBOutlet
    @IBOutlet weak var honeypotCountLabel: UILabel!
    
    @IBOutlet weak var cancelButton: CustomButton!
    @IBOutlet weak var payButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @IBAction func tappedPayButton(_ sender: Any) {
        guard let concernIndex: Int = self.concernIndex else {
            print("concernIndex 할당 오류")
            return
        }
        guard let ticketIndex: Int = self.ticketIndex else {
            print("ticketIndex 할당 오류")
            return
        }
        
        AskerPayServices.shared.postPurchase(ticketIndex: ticketIndex) { pay3 in
            self.pay3 = pay3
            print("================")
            print("고민 결제 3 완료, 이제 최종 결제 해야 함.")
            
            print("\(String(describing: self.pay3))")
            
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
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // 화면 setup
        setUp()
    }
    
    // MARK: - Methods
    private func setUp() {
        if let idx = ticketIndex {
            honeypotCountLabel.text = tickets?[idx - 1].amount
            
            self.loadViewIfNeeded()
        }
    }
}
