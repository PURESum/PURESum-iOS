//
//  AskerSearchingRequestViewController.swift
//  Willson
//
//  Created by JHKim on 15/09/2019.
//

import UIKit

/*
 1. 고민 내용 작성
 2. 고민 신청 완료 -> x-token, 내용 만 넣어서 보냄
 3. concern 테이블에 고민 생성됨
 4. 고민 내용 기반으로 카테고리 판별해서 윌슨 db에서 유사한 윌스너 3명 추출함
 5. 윌스너 3명 인덱스, 고민 인덱스 보냄 (api 추가 ㅠㅠㅠ고마워윰 ㅜㅜ)
 6. 매치 테이블 만들어짐
 7. 이후 채팅방 개설부터 원래대로
 */

class AskerSearchingRequestViewController: UIViewController {

    // MARK: - properties
    var timeSeconds: Int = 0
    var timer = Timer()
    
    var concernIndex: Int?
    
    // predict response model
    var predict: Predict?
    // 재희 매칭 response model
    var matchPredict: MatchPredict?
    
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
        // 로딩중 시작
        self.activityIndicator.startAnimating()
        
        // timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeLimit), userInfo: nil, repeats: true)
        
        // network
        matching()
    }

    // MARK: - Methods
    
    // networking
    private func matching() {
        guard let content: String = UserDefaults.standard.value(forKey: "content") as? String else {
            print("content 할당 오류")
            return
        }
        PredictServices.shared.postPredict(content: content) { predict in
            
            self.predict = predict
            print("========")
            print("POST /predict 통신 성공")
            print(String(describing: self.predict))
            
            guard let concernIndex: Int = self.concernIndex else {
                print("matching(): concernIndex 할당 오류")
                return
            }
            
            var willsonerIndex: [Int] = []
            if let counselors = self.predict?.data.predict.counselor {
                for counselor in counselors {
                    willsonerIndex.append(counselor.willsonerIdx)
                }
                
                guard let willsonerIndex: [Int] = willsonerIndex else {
                    print("willsonerIndex 할당 오류")
                    return
                }
                print("willsonerIndex: \(willsonerIndex)")
                
                AskerRequestServices.shared.postMatchPredict(concernIndex: concernIndex, willsonerIndex: willsonerIndex) { matchPredict in
                    self.matchPredict = matchPredict
                    print("========")
                    print("POST 재희 매칭 통신 성공")
                    self.timeLimitStop()
                }
            }
        }
    }
    
    // timer
    @objc private func timeLimit() {
        let timerFormatter = DateFormatter()
        
        timeSeconds += 1
        timeLabel.text = "\(timeSeconds / 60):\(timeSeconds % 60)"
        timerFormatter.dateFormat = "mm:ss"
        if let formattime = timerFormatter.date(from:timeLabel.text ?? "") {
            timeLabel.text = timerFormatter.string(from: formattime)
        }
    }
    
    private func timeLimitStop() {
        timer.invalidate()
        
        // 화면 이동
        guard let vc = UIStoryboard(name: "AskerRequest", bundle: nil).instantiateViewController(withIdentifier: "AskerApplyConcernViewController") as? AskerApplyConcernViewController else {
            print("AskerApplyConcernViewController 할당 오류")
            return
        }
        vc.concernIndex = self.concernIndex
        
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
