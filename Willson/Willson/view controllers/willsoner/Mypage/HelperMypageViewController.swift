//
//  HelperMypageViewController.swift
//  Willson
//
//  Created by JHKim on 11/10/2019.
//

import UIKit
import Kingfisher
import Toast_Swift

class HelperMypageViewController: UIViewController {
    
    // MARK: - properties
    let titleArray: [String] = ["윌슨 소개", "공지사항", "1:1 문의", "알림", "앱버전", "로그아웃"]
    
    let cellIdentifier: String = "MyPageTableViewCell"
    
    // 마이페이지 홈 (윌스너) response model
    var mypageHome: WillsonerMypageHome?
    var mypageHomeData: WillsonerMypageHomeData?
    
    // MARK: - IBOutlet
    // 닉네임 / 이미지 / 이메일 / 프로필 수정
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editProfileButton: CustomButton!
    
    // 헬퍼 등록 버튼 / view
    @IBOutlet weak var applyWillsonerButtonView: CustomView!
    
    @IBOutlet weak var profileView: UIView!
    
    @IBOutlet weak var starImageView: UIImageView!
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var oneLineLabel: UILabel!
    @IBOutlet weak var hashtagLabel: UILabel!
    
    // 코인
    
    
    // 상담 내역 / 리뷰 관리
    @IBOutlet weak var chatHistoryButtonView: UIStackView!
    @IBOutlet weak var reviewButtonView: UIStackView!
    
    // 테이블 뷰
    @IBOutlet weak var tableView: UITableView!
    
    // 사용자 전환
    @IBOutlet weak var convertButtonView: UIStackView!
    
    // MARK: - IBAction
    // 프로필 수정
    @IBAction func tappedEditProfileButton(_ sender: Any) {
        
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 마이페이지 홈 통신
        getMypageHome()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // tableview delegate, datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 57
        
        // 헬퍼 등록하러 가기
        let applyWillsonerGesture = UITapGestureRecognizer(target: self, action: #selector(tappedApplyWillsonerButtonView(_:)))
        applyWillsonerButtonView.addGestureRecognizer(applyWillsonerGesture)
        
        // 상담 내역 / 리뷰 관리
        let chatHistoryGesture = UITapGestureRecognizer(target: self, action: #selector(tappedChatHistoryButtonView(_:)))
        chatHistoryButtonView.addGestureRecognizer(chatHistoryGesture)
        let reviewGesture = UITapGestureRecognizer(target: self, action: #selector(tappedReviewButtonView(_:)))
        reviewButtonView.addGestureRecognizer(reviewGesture)
        
        // 사용자 전환
        let convertGesture = UITapGestureRecognizer(target: self, action: #selector(tappedConvertButtonVIew(_:)))
        convertButtonView.addGestureRecognizer(convertGesture)
    }

    // MARK: - Methods
    // 마이페이지 홈 통신
    func getMypageHome() {
        WillsonerMypageServices.shared.getWillsonerMypageHome() { mypageHome in
            self.mypageHome = mypageHome
            self.mypageHomeData = self.mypageHome?.data
            print("==================")
            print("마이페이지 (윌스너) 홈 통신 성공")
            
            // view에 data 표시하기
            // 닉네임
            guard let nickname = self.mypageHomeData?.nickname else {
                print("getMypageHome: nickname 할당 오류")
                return
            }
            self.nicknameLabel.text = "\(nickname) 님"
            // 이메일
            guard let email = self.mypageHomeData?.email else {
                print("getMypageHome: email 할당 오류")
                return
            }
            self.emailLabel.text = email
            
            // 윌스너 등록 확인
            if self.mypageHomeData?.willsoner != nil {
                // 프로필 이미지
                guard let urlString = self.mypageHomeData?.willsoner?.image.pic else {
                    print("gesMypageHome: 이미지 url 할당 오류")
                    return
                }
                let url = URL(string: urlString)
                self.profileImageView.kf.setImage(with: url)
                // 프로필 수정 버튼 보이기
                self.editProfileButton.isHidden = false
                
                // 윌스너 정보 보이기
                self.profileView.isHidden = false
                self.applyWillsonerButtonView.isHidden = true
                
                // 별점
                if let rate = self.mypageHomeData?.willsoner?.avgRating {
                    self.rateLabel.text = rate
                }else {
                    print("getMypageHome: rate 할당 오류")
                    self.rateLabel.text = "0.0"
                }
                
                // 한줄 소개
                guard let oneLine = self.mypageHomeData?.willsoner?.introduction else {
                    print("getMypageHome: oneLine 할당 오류")
                    return
                }
                self.oneLineLabel.text = oneLine
                // 해시 태그
                guard let hashtags = self.mypageHomeData?.willsoner?.keywords else {
                    print("getMypageHome: hashtags 할당 오류")
                    return
                }
                var hashtagText = ""
                for hashtag in hashtags {
                    hashtagText += "#\(hashtag.name) "
                }
                self.hashtagLabel.text = hashtagText
            } else {
                // 프로필 이미지
                self.profileImageView.image = UIImage(named: "imgBearGood")
                // 프로필 수정 버튼 가리기
                self.editProfileButton.isHidden = true
                
                // 윌스너 등록하러 가기 보이기
                self.profileView.isHidden = true
                self.applyWillsonerButtonView.isHidden = false
            }
            
            self.loadViewIfNeeded()
        }
    }
    
    // 헬퍼 등록하러 가기
    @objc func tappedApplyWillsonerButtonView(_ gesture: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "HelperApplication", bundle: nil).instantiateViewController(withIdentifier: "HelperApplicationNavi")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // 상담 내역 / 리뷰 관리
    @objc func tappedChatHistoryButtonView(_ gesture: UITapGestureRecognizer) {
        
    }
    @objc func tappedReviewButtonView(_ gesture: UITapGestureRecognizer) {
        
    }
    
    // 사용자 전환
    @objc func tappedConvertButtonVIew(_ gesture: UITapGestureRecognizer) {
        guard let vc = UIStoryboard(name: "AskerTabbar", bundle: nil).instantiateViewController(withIdentifier: "AskerTabbarController") as? UITabBarController else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - UITableViewDelegate
extension HelperMypageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        // 공지사항
        case 1...4:
            // *임시
            self.view.makeToast("준비 중입니다.",
            duration: 3.0,
            position: .bottom,
             style: ToastStyle())
        // 로그아웃
        case 5:
            // alert
            let alert = UIAlertController(title: nil, message: "로그아웃 하시겠습니까?", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "취소", style: .cancel)
            let ok = UIAlertAction(title: "로그아웃", style: .default) { (_) in
                UserDefaults.standard.removeObject(forKey: "kakaoID")
                // login 화면으로 이동
                guard let vc: LoginViewController = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
                    print("didSelectRowAt: LoginViewController 할당 오류")
                    return
                }
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true, completion: nil)
            }
            alert.addAction(cancel)
            alert.addAction(ok)
            
            self.present(alert, animated: true, completion: nil)
        default: return
        }
    }
}

// MARK: - UITableViewDataSource
extension HelperMypageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MyPageTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MyPageTableViewCell else { return UITableViewCell() }
        
        cell.label.text = titleArray[indexPath.row]
        switch indexPath.row {
        case 0...4:
            cell.disclosureImageView.image = UIImage(named: "icRightClampGray")
            cell.disclosureImageView.isHidden = false
        case 5:
            cell.disclosureImageView.isHidden = true
        default: break
        }
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return cell
    }
}
