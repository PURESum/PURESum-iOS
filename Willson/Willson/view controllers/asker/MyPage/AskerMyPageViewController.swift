//
//  AskerMyPageViewController.swift
//  Willson
//
//  Created by JHKim on 01/10/2019.
//

import UIKit
import Toast_Swift

class AskerMyPageViewController: UIViewController {

    // MARK: - properties
    let titleArray: [String] = ["윌슨 소개", "공지사항", "1:1 문의", "알림", "앱버전", "로그아웃"]
    
    let cellIdentifier: String = "MyPageTableViewCell"
    
    // 마이페이지(질문자) 홈 response model
    var mypageHome: AskerMypageHome?
    var mypageHomeData: AskerMypageHomeData?
    
    // MARK: - IBOutlet
    // 닉네임
    @IBOutlet weak var nicknameLabel: UILabel!
    // 이미지
    @IBOutlet weak var profileImageView: CustomImageView!
    // 이메일
    @IBOutlet weak var emailLabel: UILabel!
    // 프로필 수정 버튼
    @IBOutlet weak var editProfileButton: CustomButton!
    
    // 보유한 꿀단지
    @IBOutlet weak var honeypotCountLabel: UILabel!
    @IBOutlet weak var buyHoneypotButton: UIButton!
    
    
    // 쿠폰 / 상담 내역 / 리뷰 관리
    @IBOutlet weak var couponButtonView: UIStackView!
    @IBOutlet weak var historyButtonView: UIStackView!
    @IBOutlet weak var manageReviewButtonView: UIStackView!
    
    // tableView
    @IBOutlet weak var tableView: UITableView!
    
    // 사용자 전환
    @IBOutlet weak var convertButtonView: CustomView!
    
    // MARK: - IBAction
    // 프로필 수정
    @IBAction func tappedEditProfile(_ sender: Any) {
        /*
        let vc = UIStoryboard(name: "AskerMypage", bundle: nil).instantiateViewController(withIdentifier: "AskerEditProfileViewController")
        self.show(vc, sender: nil)
        */
        // *임시
        self.view.makeToast("준비 중입니다.",
        duration: 3.0,
        position: .bottom,
         style: ToastStyle())
    }
    
    @IBAction func tappedRefundButton(_ sender: Any) {
        // *임시
        self.view.makeToast("준비 중입니다.",
        duration: 3.0,
        position: .bottom,
         style: ToastStyle())
    }
    
    @IBAction func tappedBuyHoneypot(_ sender: Any) {
        // *임시
        self.view.makeToast("준비 중입니다.",
        duration: 3.0,
        position: .bottom,
         style: ToastStyle())
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
        
        // add tapgesture
        // 상담권
        /*
        let ticketGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedTicketButtonView(_:)))
        ticketButtonView.addGestureRecognizer(ticketGesture)
        */
        
        // 쿠폰 / 상담 내역 / 리뷰 관리
        let pointGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedCouponButtonView(_:)))
        couponButtonView.addGestureRecognizer(pointGesture)
        let historyGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedHistoryButtonView(_:)))
        historyButtonView.addGestureRecognizer(historyGesture)
        let reviewGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedReviewButtonView(_:)))
        manageReviewButtonView.addGestureRecognizer(reviewGesture)
        
        // 사용자 전환
        let convertGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedConvertButtonView(_:)))
        convertButtonView.addGestureRecognizer(convertGesture)
    }
    
    // MARK: - Methods
    // 마이페이지 (질문자) 홈 통신
    func getMypageHome() {
        AskerMypageServices.shared.getAskerMypageHome { mypageHome in
            self.mypageHome = mypageHome
            self.mypageHomeData = self.mypageHome?.data
            print("==============")
            print("마이페이지(질문자) 홈 통신 성공")
            
            // 닉네임
            guard let nickname = self.mypageHomeData?.nickname else {
                print("getMypageHome: nickname 할당 오류")
                return
            }
            self.nicknameLabel.text = "\(nickname) 님"
            // 프로필 이미지
            self.profileImageView.image = UIImage(named: "imgBearGood")
            // 이메일
            guard let email = self.mypageHomeData?.email else {
                print("getMypageHome: email 할당 오류")
                return
            }
            self.emailLabel.text = email
            
            // 보유한 꿀단지
            if let honeypotCount = self.mypageHomeData?.point?.honeypot {
                self.honeypotCountLabel.text = honeypotCount
            } else {
                self.honeypotCountLabel.text = "0개"
            }
        }
    }
    
    // 상담권
    @objc func tappedTicketButtonView(_ gesture: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "AskerMypage", bundle: nil).instantiateViewController(withIdentifier: "AskerManagePointViewController")
        self.show(vc, sender: nil)
    }
    
    // 쿠폰 / 상담 내역 / 리뷰 관리
    @objc func tappedCouponButtonView(_ gesture: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "AskerMypage", bundle: nil).instantiateViewController(withIdentifier: "AskerCouponViewController")
        self.show(vc, sender: nil)
    }
    
    @objc func tappedHistoryButtonView(_ gesture: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "AskerMypage", bundle: nil).instantiateViewController(withIdentifier: "AskerChatHistoryViewController")
        self.show(vc, sender: nil)
    }
    
    @objc func tappedReviewButtonView(_ gesture: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "AskerMypage", bundle: nil).instantiateViewController(withIdentifier: "AskerMypageReviewViewController")
        self.show(vc, sender: nil)
    }
    
    // 사용자 전환
    @objc func tappedConvertButtonView(_ gesture: UITapGestureRecognizer) {
        guard let vc = UIStoryboard(name: "HelperTabbar", bundle: nil).instantiateViewController(withIdentifier: "HelperTabbarController") as? UITabBarController else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

extension AskerMyPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        // 공지사항
        case 1:
            let vc = UIStoryboard(name: "AskerMypage", bundle: nil).instantiateViewController(withIdentifier: "AskerMypageNoticeViewController")
            self.show(vc, sender: nil)
        case 2...4:
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

extension AskerMyPageViewController: UITableViewDataSource {
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
