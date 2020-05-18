//
//  AskerSearchingRequestViewController.swift
//  Willson
//
//  Created by JHKim on 15/09/2019.
//

import UIKit

class AskerSearchingRequestViewController: UIViewController {

    // MARK: - properties
    var timeSeconds: Int = 0
    var timer = Timer()
    
    var concernIndex: Int?
    
    lazy var activityIndicator: UIActivityIndicatorView = {
        // Create an indicator.
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center = self.view.center
        activityIndicator.color = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        // Also show the indicator even when the animation is stopped.
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = UIActivityIndicatorView.Style.white
        // Start animation.
        activityIndicator.stopAnimating()
        return activityIndicator
    }()
    
    @IBOutlet weak var xbutton: UIBarButtonItem!
    
    // MARK: - IBOutlet
    @IBOutlet weak var timeLabel: UILabel!
    
    // MARK: - IBAction
    @IBAction func tappedXButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // hide backbutton
        self.navigationItem.hidesBackButton = true
        
        // 로딩중
        self.view.addSubview(self.activityIndicator)
        
        // timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeLimit), userInfo: nil, repeats: true)
        
        // network
        matching()
    }

    // MARK: - Methods
    
    // networking
    private func matching() {
        
    }
    
    // timer
    @objc func timeLimit() {
        let timerFormatter = DateFormatter()
        
        timeSeconds += 1
        timeLabel.text = "\(timeSeconds / 60):\(timeSeconds % 60)"
        timerFormatter.dateFormat = "mm:ss"
        if let formattime = timerFormatter.date(from:timeLabel.text ?? "") {
            timeLabel.text = timerFormatter.string(from: formattime)
        }
    }
    
    func timeLimitStop() {
        timer.invalidate()
        
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
        // 인디케이터 중지
        self.activityIndicator.stopAnimating()
        self.present(tabBarController, animated: true)
    }
}
