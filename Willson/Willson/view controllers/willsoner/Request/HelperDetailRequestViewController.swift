//
//  HelperDetailRequestViewController.swift
//  Willson
//
//  Created by JHKim on 2019/11/27.
//

import UIKit

class HelperDetailRequestViewController: UIViewController {

    // MARK: - properties
    // 선택된 매치 인덱스 값 - 이전 화면에서 받아옴
    var matchIndex: Int?
    
    // Match reponse model
    var match: Match?
    var matchData: MatchData?
    
    // Select response model
    var select: WillsonerRealtimeSelect?
    
    // titmer
    var remainingSeconds: Int?
    var timer = Timer()
    
    // MARK: - IBOutlet
    @IBOutlet weak var subCategoryLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var hashTagLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var introductionLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var ageAndSexLabel: UILabel!
    
    @IBOutlet weak var selectButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedButton(_ sender: Any) {
        guard let matchIndex = self.matchIndex else {
            print("matchIndex nil 값")
            return
        }
        // PATCH 통신
        WillsonerConcernServices.shared.patchSelect(matchIndex: matchIndex) { select in
            self.select = select
            print(self.select ?? "")
            print("==============")
            print("매칭 수락 통신 성공")
            
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 매칭 상세 페이지 통신
        getMatch()
        
        // timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeLimit), userInfo: nil, repeats: true)
    }
    
    // MARK: - Methods
    
    func getMatch() {
        guard let matchIndex = self.matchIndex else {
            print("matchIndex nil 값")
            return
        }
        
        WillsonerConcernServices.shared.getMatch(matchIndex: matchIndex) { match in
            self.match = match
            self.matchData = self.match?.data
            print("==============")
            print("매칭 상세 페이지 통신 성공")
            
            self.setUpViews()
        }
    }
    
    // timer
    @objc func timeLimit() {
        let timerFormatter = DateFormatter()
        
        if remainingSeconds! > 0 {
            remainingSeconds! -= 1
            timeLabel.text = "\((remainingSeconds!) / 60):\((remainingSeconds!) % 60)"
            timerFormatter.dateFormat = "mm:ss"
            if let formattime = timerFormatter.date(from:timeLabel.text ?? "") {
                timeLabel.text = timerFormatter.string(from: formattime)
            }
        } else {
            timeLimitStop()
        }
    }
    
    func timeLimitStop() {
        timer.invalidate()
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpViews() {
        // 네비바 - 카테고리
        
        // 세부 카테고리 (ex. #취업)
        guard let subcategory = matchData?.concern.subcategory.name else {
            print("matchData?.concern.subcategory.name 할당 오류")
            return
        }
        subCategoryLabel.text = subcategory
        
        // 내용
        guard let content = matchData?.concern.content else {
            print("matchData?.concern.content 할당 오류")
            return
        }
        contentTextView.text = content
        
        // 해시태그
        guard let hashTages = matchData?.concern.feelings else {
            print("matchData?.concern.feelings 할당 오류")
            return
        }
        var feelings = ""
        for hasTag in hashTages {
            feelings += "#\(hasTag.name) "
        }
        hashTagLabel.text = feelings
        
        // 이미지
        
        // 한줄 소개
        if let direction = matchData?.concern.direction.name {
            introductionLabel.text = direction
        } else {
            introductionLabel.text = ""
        }
        
        // 이름
        guard let name = matchData?.concern.asker.nickname else {
            print("matchData?.concern.asker.nickname 할당 오류")
            return
        }
        nameLabel.text = name
        
        // 나이 / 성별
        guard let age = matchData?.concern.asker.age else {
            print("matchData?.concern.asker.age 할당 오류")
            return
        }
        guard let gender = matchData?.concern.asker.gender else {
            print("matchData?.concern.asker.gender 할당 오류")
            return
        }
        
        ageAndSexLabel.text = "\(age) / \(gender)"
    }

}
