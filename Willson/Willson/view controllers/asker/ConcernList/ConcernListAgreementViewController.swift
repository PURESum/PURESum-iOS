//
//  ConcernListAgreementViewController.swift
//  Willson
//
//  Created by JHKim on 06/10/2019.
//

import UIKit

class ConcernListAgreementViewController: UIViewController {

    // MARK: - properties
    // 고민신청 완료 networking response model
    var requestComplete: RequestComplete?
    
    // 로딩중 인디케이터
    lazy var activityIndicator: UIActivityIndicatorView = {
            // Create an indicator.
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.center = self.view.center
            activityIndicator.color = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
            // Also show the indicator even when the animation is stopped.
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.white
            // Start animation.
            activityIndicator.stopAnimating()
            return activityIndicator
        }()
    
    // MARK: - IBOutlet
    @IBOutlet weak var agreementTextView: UITextView!
    @IBOutlet weak var textviewBGView: UIView!
    
    @IBOutlet weak var allContentButton: UIButton!
    
    @IBOutlet weak var allCheckView: UIView!
    // ic_check_circle_gray
    @IBOutlet weak var allcheckImageView: UIImageView!
    
    @IBOutlet weak var confirmView: UIView!
    // ic_check_bold_gray
    @IBOutlet weak var confirmCheckImageView: UIImageView!
    
    @IBOutlet weak var secretView: UIView!
    @IBOutlet weak var secretCheckImageView: UIImageView!
    
    @IBOutlet weak var finishButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedAllInfoButton(_ sender: Any) {
        let vc = UIStoryboard(name: "AskerConcernList", bundle: nil).instantiateViewController(withIdentifier: "ConcernPopUpAgreementViewController")
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
  
    @IBAction func tappedCompleteButton(_ sender: Any) {
        // 로딩중 시작
        self.activityIndicator.startAnimating()

        // POST 통신
        guard let content: String = UserDefaults.standard.value(forKey: "content") as? String else {
            print("UserDefaults - content 할당 오류")
            return
        }
        print("UserDefaults - content: \n\(content)")

        AskerRequestServices.shared.postRequestComplete(content: content) { requestComplete in
            self.requestComplete = requestComplete
            print(self.requestComplete ?? "")
            
            // 결제 페이지로 이동
            guard let vc: AskerSearchingRequestViewController = UIStoryboard(name: "AskerRequest", bundle: nil).instantiateViewController(withIdentifier: "AskerSearchingRequestViewController") as? AskerSearchingRequestViewController else {
                print("AskerSearchingRequestViewController 할당 오류")
                return
            }
            
            guard let concernIndex = self.requestComplete?.data?.idx else {
                print("concern index 할당 오류")
                return
            }
            // 고민 인덱스 넘기기
            vc.concernIndex = concernIndex
            
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
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // textview bg color
        textviewBGView.backgroundColor = #colorLiteral(red: 0.9764705882, green: 0.9764705882, blue: 0.9764705882, alpha: 1)
        
        // add gesture
        let allcheckGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedAllcheckView(_:)))
        let confirmGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedConfirmView(_:)))
        let secretGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedSecretView(_:)))
        allCheckView.addGestureRecognizer(allcheckGesture)
        confirmView.addGestureRecognizer(confirmGesture)
        secretView.addGestureRecognizer(secretGesture)
        
        // 처음에 완료 버튼 비활성화
        finishButton.isEnabled = false
        
        // 로딩중
        self.view.addSubview(self.activityIndicator)
    }

    // MARK: - Methods
    @objc func tappedAllcheckView(_ gesture: UITapGestureRecognizer) {
        if allCheckView.tag == 1 {
            allcheckImageView.image = UIImage(named: "icCheckCircleGray")
            confirmCheckImageView.image = UIImage(named: "icCheckBoldGray")
            secretCheckImageView.image = UIImage(named: "icCheckBoldGray")
            allCheckView.tag = 0
            confirmView.tag = 0
            secretView.tag = 0
        } else {
            allcheckImageView.image = UIImage(named: "icCheckCircleNavy")
            confirmCheckImageView.image = UIImage(named: "icCheckBoldNavy")
            secretCheckImageView.image = UIImage(named: "icCheckBoldNavy")
            allCheckView.tag = 1
            confirmView.tag = 1
            secretView.tag = 1
        }
        checkAllChecked()
    }
    
    @objc func tappedConfirmView(_ gesture: UITapGestureRecognizer) {
        if confirmView.tag == 1 {
            confirmCheckImageView.image = UIImage(named: "icCheckBoldGray")
            confirmView.tag = 0
            if allCheckView.tag == 1 {
                allcheckImageView.image = UIImage(named: "icCheckCircleGray")
                allCheckView.tag = 0
            }
        } else {
            confirmCheckImageView.image = UIImage(named: "icCheckBoldNavy")
            confirmView.tag = 1
            if secretView.tag == 1 {
                allcheckImageView.image = UIImage(named: "icCheckCircleNavy")
                allCheckView.tag = 1
            }
        }
        checkAllChecked()
    }
    
    @objc func tappedSecretView(_ gesture: UITapGestureRecognizer) {
        if secretView.tag == 1 {
            secretCheckImageView.image = UIImage(named: "icCheckBoldGray")
            secretView.tag = 0
            if allCheckView.tag == 1 {
                allcheckImageView.image = UIImage(named: "icCheckCircleGray")
                allCheckView.tag = 0
            }
        } else {
            secretCheckImageView.image = UIImage(named: "icCheckBoldNavy")
            secretView.tag = 1
            if confirmView.tag == 1 {
                allcheckImageView.image = UIImage(named: "icCheckCircleNavy")
                allCheckView.tag = 1
            }
        }
        checkAllChecked()
    }
    
    func checkAllChecked() {
        if allCheckView.tag == 1 {
            finishButton.isEnabled = true
        } else {
            finishButton.isEnabled = false
        }
    }
}
