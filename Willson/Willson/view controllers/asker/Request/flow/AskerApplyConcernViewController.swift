//
//  AskerApplyConcernViewController.swift
//  Willson
//
//  Created by JHKim on 2020/02/09.
//

import UIKit

class AskerApplyConcernViewController: UIViewController {

    // MARK: - properties
    // 고민 목록 response model
    var concern: Concern?
    var concerns: Concerns?
    
    // collectionview cell identifier
    let cellIdentifier: String = "RequestConcernCollectionViewCell"
    let headerViewIdentifier: String = "RequestConcernHeaderCollectionReusableView"
    let footerViewIdentifier: String = "RequestConcernFooterCollectionReusableView"
    
    let defaultCellIdentifier: String = "RequestDefaultCollectionViewCell"
    
    // timer
    var timer = [Int: Timer]()
    
    // MARK: - IBOutlet
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var applyButton: UIButton!
    
    @IBOutlet weak var contentView: UIView!
    
    // default
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var applyButtonView: CustomView!
    
    
    // request
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - IBAction
    // 고민 신청하러 가기 버튼 눌렀을 때
    @IBAction func tappedApplyButton(_ sender: Any) {
        /* 고민 신청 탭으로 가는 코드.. 왜 여기 있지
        let tabbarStoryboard = UIStoryboard(name: "AskerTabbar", bundle: nil)
        guard let tabBarController: UITabBarController = tabbarStoryboard.instantiateViewController(withIdentifier: "AskerTabbarController") as? UITabBarController else { return }
        
        tabBarController.selectedIndex = 1
        
        let navi = UIStoryboard(name: "AskerTabbar", bundle: nil).instantiateViewController(withIdentifier: "AskerRequestConcernListNavi")
        
        tabBarController.viewControllers?[1] = navi
        tabBarController.tabBar.items?[1].image = UIImage(named: "icTabListGray")
        tabBarController.tabBar.items?[1].selectedImage = UIImage(named: "icTabListNavy")
        tabBarController.tabBar.items?[1].title = "상담신청"
        
        tabBarController.modalPresentationStyle = .fullScreen
        self.present(tabBarController, animated: true)
         */
        print("tapped Apply Button !")
        
        let vc = UIStoryboard(name: "AskerConcernList", bundle: nil).instantiateViewController(withIdentifier: "ConcernListNavigationController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // navibar hidden
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // 고민 목록 GET 통신
        getConcerns()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // apply button action
        let applyButtonViewTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedApplyButtonView(_:)))
        applyButtonView.addGestureRecognizer(applyButtonViewTapGesture)
        
        // collectionview delegate, datasource
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // 고민 목록 GET 통신
//        getConcerns()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // navibar hidden
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Methods
    func getConcerns() {
        AskerConcernServices.shared.getConcerns() { concern in
            self.concern = concern
            self.concerns = self.concern?.data
            
            print("===================")
            print("고민 목록 통신 성공")
            
            /* 고민 카운트 임시
            guard let realtimeCount = self.concerns?.realtime?.count else {
                print("realtime count 할당 오류")
                return
            }
            
            guard let reserveCount = self.concerns?.reserve?.count else {
                print("reserve count 할당 오류")
                return
            }
            // count label
            let count = realtimeCount + reserveCount
            */
            
            // total count로 표시 - 완료된 고민도 포함해서 count
            if let count = self.concerns?.totalCount {
                if count == 0 {
                    // 고민 없을 때
                    self.countLabel.text = "0"
                    self.view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
                    self.collectionView.isHidden = true
                } else {
                    // 고민 개수 1개 이상
                    self.countLabel.text = "\(count)"
                    self.view.backgroundColor = .white
                    self.collectionView.isHidden = false
                    
                    self.collectionView.reloadData()
                }
            } else {
                // 고민 없을 때
                self.countLabel.text = "0"
                self.view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
                self.collectionView.isHidden = true
            }
        }
    }
    
    // apply button action
    @objc func tappedApplyButtonView(_ gesture: UITapGestureRecognizer) {
        print("tapped RequestConcernView!")
        
        let vc = UIStoryboard(name: "AskerConcernList", bundle: nil).instantiateViewController(withIdentifier: "ConcernListNavigationController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // timer
    @objc func runScheduledTask(_ runningTimer: Timer) {
        let dict = runningTimer.userInfo as? [String: UILabel]
        let timerFormatter = DateFormatter()
        
        if let label: UILabel = (dict?["cell"]) {
            label.text = ""
            if let timerCount = concerns?.realtime?.rows?[label.tag].timer {
                let date = Date(timeIntervalSince1970: TimeInterval(timerCount / 1000))
                var remainingSeconds: Int = Int(date.timeIntervalSinceNow)
                remainingSeconds -= 1
                if remainingSeconds >= 0 {
                    label.text = "\(remainingSeconds / 60):\(remainingSeconds % 60)"
                    timerFormatter.dateFormat = "mm:ss"
                    if let formattime = timerFormatter.date(from:label.text ?? "") {
                        label.text = "\(timerFormatter.string(from: formattime))"
                    }
                } else if remainingSeconds > -300 {
                    if label.textColor != #colorLiteral(red: 0.1254901961, green: 0.8078431373, blue: 0, alpha: 1) {
                        getConcerns()
                    }
                    if remainingSeconds == -1 {
                        getConcerns()
                    }
                    label.text = "\((300 + remainingSeconds) / 60):\((300 + remainingSeconds) % 60)"
                    timerFormatter.dateFormat = "mm:ss"
                    if let formattime = timerFormatter.date(from:label.text ?? "") {
                        label.text = "\(timerFormatter.string(from: formattime))"
                    }
                    
                } else if remainingSeconds == -300 {
                    runningTimer.invalidate()
                    getConcerns()
                }
            } else {
                print("timerCount 할당 오류")
                runningTimer.invalidate()
                getConcerns()
            }
        }
    }
}

extension AskerApplyConcernViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
        guard let searchingVC: AskerSearchingRequestViewController = UIStoryboard(name: "AskerRequest", bundle: nil).instantiateViewController(withIdentifier: "AskerSearchingRequestViewController") as? AskerSearchingRequestViewController else {
            print("did selected item at: AskerSearchingRequestViewController 할당 오류")
            return
        }
        */
        guard let searchingVC: AskerSearchingWillsonerViewController = UIStoryboard(name: "AskerRequest", bundle: nil).instantiateViewController(withIdentifier: "AskerSearchingWillsonerViewController") as? AskerSearchingWillsonerViewController else {
            print("did selected itme at: AskerSearchingWillsonerViewController 할당 오류")
            return
        }
        guard let listVC: AskerRequestWillsonerListViewController = UIStoryboard(name: "AskerRequest", bundle: nil).instantiateViewController(withIdentifier: "AskerRequestWillsonerListViewController") as? AskerRequestWillsonerListViewController else {
            print("didSelectItemAt: AskerRequestWillsonerListViewController 할당 오류")
            return
        }
        
        switch indexPath.section {
        case 0:
            if concerns?.realtime?.count == 0 {
                
            } else {
                guard let index = concerns?.realtime?.rows?[indexPath.item].idx else {
                    print("concernsData?.rows[indexPath.item].idx 할당 오류")
                    return
                }
                // 타이머에 따라서
                guard let timerCount = concerns?.realtime?.rows?[indexPath.item].timer else {
                    print("timerCount 할당 오류")
                    return
                }
                let date = Date(timeIntervalSince1970: TimeInterval(timerCount / 1000))
                let remainingSeconds: Int = Int(date.timeIntervalSinceNow)
                if remainingSeconds <= 0 {
                    if concerns?.realtime?.rows?[indexPath.item].status == "init" {
                        listVC.remainingSeconds = remainingSeconds
                        listVC.index = index
                        self.navigationController?.pushViewController(listVC, animated: true)
                    }
                }
                else {
                    searchingVC.remainingSeconds = remainingSeconds
                    // self.navigationController?.pushViewController(searchingVC, animated: true)
                    searchingVC.modalPresentationStyle = .overFullScreen
                    self.present(searchingVC, animated: false, completion: nil)
                }
            }
        case 1:
            if concerns?.reserve?.count == 0 {
                return
            } else {
                guard let index = concerns?.reserve?.rows?[indexPath.item].idx else {
                    print("concernsData?.rows[indexPath.item].idx 할당 오류")
                    return
                }
                listVC.index = index
                self.navigationController?.pushViewController(listVC, animated: true)
            }
        case 2:
            /*
             guard let index = concerns?.completed?.rows?[indexPath.item].idx else {
             print("concernsData?.rows[indexPath.item].idx 할당 오류")
             return
             }
            vc.index = index
             */
            return
        default: return
        }
        
    }
}

extension AskerApplyConcernViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let realtimeCount = concerns?.realtime?.count {
                if realtimeCount == 0 {
                    return 1
                } else {
                    return realtimeCount
                }
            } else {
                print("concernsData.count 할당 오류 - numberOfItemsInSection")
                return 0
            }
        case 1:
            if let reserveCount = concerns?.reserve?.count {
                if reserveCount == 0 {
                    return 1
                } else {
                    return reserveCount
                }
            } else {
                print("concernsData.count 할당 오류 - numberOfItemsInSection")
                return 0
            }
        case 2:
            if let completedCount = concerns?.completed?.count {
                if completedCount == 0 {
                    return 1
                } else {
                    return completedCount
                }
            } else {
                print("concernsData.count 할당 오류 - numberOfItemsInSection")
                return 0
            }
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header: RequestConcernHeaderCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerViewIdentifier, for: indexPath) as? RequestConcernHeaderCollectionReusableView else {
                print("header cell 할당 오류")
                return UICollectionReusableView()
            }
            
            switch indexPath.section {
            case 0:
                header.titleLabel.text = "실시간"
                if let realtimeCount = concerns?.realtime?.count {
                    header.countLabel.text = "\(realtimeCount)"
                } else {
                    print("realtime count 할당 오류 - dequeueReusableSupplementaryView")
                    header.countLabel.text = "0"
                }
            case 1:
                header.titleLabel.text = "예약"
                if let reserveCount = concerns?.reserve?.count {
                    header.countLabel.text = "\(reserveCount)"
                } else {
                    print("reservce count 할당 오류 - dequeueReusableSupplementaryView")
                    header.countLabel.text = "0"
                }
            case 2:
                header.titleLabel.text = "완료된 고민"
                if let completedCount = concerns?.completed?.count {
                    header.countLabel.text = "\(completedCount)"
                } else {
                    print("completed count 할당 오류 - dequeueReusableSupplementaryView")
                    header.countLabel.text = "0"
                }
            default: return UICollectionReusableView()
            }
            
            return header
        case UICollectionView.elementKindSectionFooter:
            guard let footer: RequestConcernFooterCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerViewIdentifier, for: indexPath) as? RequestConcernFooterCollectionReusableView else {
                print("footer cell 할당 오류")
                return UICollectionReusableView()
            }
            
            switch indexPath.section {
            case 0, 1:
                footer.seperationView.isHidden = false
            case 2:
                footer.seperationView.isHidden = true
            default: return UICollectionReusableView()
            }
            
            return footer
        default: return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: RequestConcernCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? RequestConcernCollectionViewCell else {
            print("RequestConcernCollectionViewCell 할당 오류")
            return UICollectionViewCell()
        }
        
        guard let defaultCell: RequestDefaultCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: defaultCellIdentifier, for: indexPath) as? RequestDefaultCollectionViewCell else {
            print("RequestDefaultCollectionViewCell 할당 오류")
            return UICollectionViewCell()
        }
        
        switch indexPath.section {
        // 실시간
        case 0:
            if concerns?.realtime?.count == 0 {
                return defaultCell
            } else {
                // 카테고리
                guard let category = concerns?.realtime?.rows?[indexPath.item].subcategory.category.name else {
                    print("cellForItemAt - realtime category.name 할당 오류")
                    return UICollectionViewCell()
                }
                cell.categoryLabel.text = category
                
                // 서브 카테고리
                guard let subCategory = concerns?.realtime?.rows?[indexPath.item].subcategory.name else {
                    print("cellForItemAt - realtime subcategory.name 할당 오류")
                    return UICollectionViewCell()
                }
                cell.titleLabel.text = "#\(subCategory)"
                
                // 내용
                guard let content = concerns?.realtime?.rows?[indexPath.item].content else {
                    print("cellForItemAt - realtime content 할당 오류")
                    return UICollectionViewCell()
                }
                cell.contentLabel.text = content
                
                // 성격
                guard let personalities = concerns?.realtime?.rows?[indexPath.item].personalities else {
                    print("cellForItemAt - realtime personalities 할당 오류")
                    return UICollectionViewCell()
                }
                var personalitiesText = ""
                for personality in personalities {
                    personalitiesText += "#\(personality.name) "
                }
                cell.hashTagLabel.text = personalitiesText
                
                // 타이머
                if let status = concerns?.realtime?.rows?[indexPath.item].status {
                    if status == "init" {
                        if let timerCount = concerns?.realtime?.rows?[indexPath.item].timer {
                            cell.timeImageView.isHidden = false
                            
                            cell.timeLabel.isHidden = false
                            cell.timeLabel.tag = indexPath.item
                            
                            let date = Date(timeIntervalSince1970: TimeInterval(timerCount / 1000))
                            let remainingSeconds: Int = Int(date.timeIntervalSinceNow)
                            if remainingSeconds > 0 {
                                // 타이머 이미지
                                
                                cell.timeImageView.image = UIImage(named: "icSearchBlueSmall")
                                
                                // 안내 메시지
                                cell.timeAnnounceLabel.text = "윌스너 찾는 중이에요 …"
                                cell.timeAnnounceLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.5019607843, blue: 1, alpha: 1)
                                
                                // 시간 초
                                cell.timeLabel.textColor = #colorLiteral(red: 0.06666666667, green: 0.5019607843, blue: 1, alpha: 1)
                            } else if remainingSeconds > -300 {
                                // 타이머 이미지
                                cell.timeImageView.image = UIImage(named: "icCheckGreenSmall")
                                
                                // 안내 메시지
                                cell.timeAnnounceLabel.text = "윌스너를 선택해주세요 …"
                                cell.timeAnnounceLabel.textColor = #colorLiteral(red: 0.1254901961, green: 0.8078431373, blue: 0, alpha: 1)
                                
                                // 시간 초
                                cell.timeLabel.textColor = #colorLiteral(red: 0.1254901961, green: 0.8078431373, blue: 0, alpha: 1)
                            }
                        }
                        // timer
                        let t:Timer = timer[indexPath.item] ?? Timer()
                        t.invalidate()
                        timer[indexPath.item] = (Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.runScheduledTask), userInfo: ["cell": cell.timeLabel], repeats: true))
                        
                    } else if status == "matched" {
                        // 타이머 이미지
                        cell.timeImageView.image = UIImage(named: "icCheckGreenSmall")
                        
                        // 안내 메시지
                        cell.timeAnnounceLabel.text = "윌스너와 매칭이 완료되었습니다."
                        cell.timeAnnounceLabel.textColor = #colorLiteral(red: 0.1254901961, green: 0.8078431373, blue: 0, alpha: 1)
                        
                        // 시간 초
                        cell.timeLabel.isHidden = true
                    } else if status == "unmatched" {
                        // 타이머 이미지
                        cell.timeImageView.isHidden = false
                        cell.timeImageView.image = UIImage(named: "icXRedSmall")
                        
                        // 안내 메시지
                        cell.timeAnnounceLabel.text = "윌스너를 찾지 못했어요 ㅠㅠ"
                        cell.timeAnnounceLabel.textColor = #colorLiteral(red: 0.9607843137, green: 0.2901960784, blue: 0.1294117647, alpha: 1)
                        
                        // 시간 초
                        cell.timeLabel.isHidden = true
                    } else if status == "empty" {
                        // 타이머 이미지
                        cell.timeImageView.isHidden = false
                        cell.timeImageView.image = UIImage(named: "icXRedSmall")
                        
                        // 안내 메시지
                        cell.timeAnnounceLabel.text = "윌스너를 찾지 못했어요 ㅠㅠ"
                        cell.timeAnnounceLabel.textColor = #colorLiteral(red: 0.9607843137, green: 0.2901960784, blue: 0.1294117647, alpha: 1)
                        
                        // 시간 초
                        cell.timeLabel.isHidden = true
                    }
                    
                    // 타이머 hidden false
                    cell.timeImageView.isHidden = false
                    cell.timeAnnounceLabel.isHidden = false
                }
            }
            
        // 예약
        case 1:
            if concerns?.reserve?.count == 0 {
                return defaultCell
            } else {
                // 카테고리
                guard let category = concerns?.reserve?.rows?[indexPath.item].subcategory.category.name else {
                    print("cellForItemAt - reserve category 할당 오류")
                    return UICollectionViewCell()
                }
                cell.categoryLabel.text = category
                
                // 서브 카테고리
                guard let subcategory = concerns?.reserve?.rows?[indexPath.item].subcategory.name else {
                    print("cellForItemAt - reserve subCategory 할당 오류")
                    return UICollectionViewCell()
                }
                cell.titleLabel.text = subcategory
                
                // 내용
                guard let content = concerns?.reserve?.rows?[indexPath.item].content else {
                    print("cellForItemAt - reserve content 할당 오류")
                    return UICollectionViewCell()
                }
                cell.contentLabel.text = content
                
                // 성격
                guard let personalities = concerns?.reserve?.rows?[indexPath.item].personalities else {
                    print("cellForItemAt - reserve personalities 할당 오류")
                    return UICollectionViewCell()
                }
                var personalitiesText = ""
                for personality in personalities {
                    personalitiesText += "#\(personality.name) "
                }
                cell.hashTagLabel.text = personalitiesText
                
                // 타이머 hidden
                cell.timeImageView.isHidden = true
                cell.timeLabel.isHidden = true
                cell.timeAnnounceLabel.isHidden = false
            }
        
        // 완료된 고민
        case 2:
            if concerns?.completed?.count == 0 {
                return defaultCell
            } else {
                // 카테고리
                guard let category = concerns?.completed?.rows?[indexPath.item].subcategory.category.name else {
                    print("cellForItemAt - completed category 할당 오류")
                    return UICollectionViewCell()
                }
                cell.categoryLabel.text = category
                
                // 서브 카테고리
                guard let subcategory = concerns?.completed?.rows?[indexPath.item].subcategory.name else {
                    print("cellForItemAt - completed subCategory 할당 오류")
                    return UICollectionViewCell()
                }
                cell.titleLabel.text = subcategory
                
                // 내용
                guard let content = concerns?.completed?.rows?[indexPath.item].content else {
                    print("cellForItemAt - completed content 할당 오류")
                    return UICollectionViewCell()
                }
                cell.contentLabel.text = content
                
                // 성격
                guard let personalities = concerns?.completed?.rows?[indexPath.item].personalities else {
                    print("cellForItemAt - completed personalities 할당 오류")
                    return UICollectionViewCell()
                }
                var personalitiesText = ""
                for personality in personalities {
                    personalitiesText += "#\(personality.name) "
                }
                cell.hashTagLabel.text = personalitiesText
                
                // 타이머 hidden
                cell.timeImageView.isHidden = true
                cell.timeLabel.isHidden = true
                cell.timeAnnounceLabel.isHidden = true
            }
        default: return UICollectionViewCell()
        }
        
        return cell
    }
}

extension AskerApplyConcernViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 33)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 51)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch indexPath.section {
        case 0:
            if concerns?.realtime?.count == 0 {
                return CGSize(width: UIScreen.main.bounds.width, height: 87)
            } else {
                return CGSize(width: UIScreen.main.bounds.width, height: 273)
            }
        case 1:
            if concerns?.reserve?.count == 0 {
                return CGSize(width: UIScreen.main.bounds.width, height: 87)
            } else {
                return CGSize(width: UIScreen.main.bounds.width, height: 273)
            }
        case 2:
            if concerns?.completed?.count ==  0 {
                return CGSize(width: UIScreen.main.bounds.width, height: 87)
            } else {
                return CGSize(width: UIScreen.main.bounds.width, height: 227)
            }
        default:
            return CGSize(width: 0, height: 0)
        }
    }
}
