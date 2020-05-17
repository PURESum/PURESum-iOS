//
//  HelperRequestViewController.swift
//  Willson
//
//  Created by JHKim on 2020/03/01.
//

import UIKit

class HelperRequestViewController: UIViewController {

    // MARK: - properties
    let categoryCellIdentifier: String = "AskerHomeRecommandCategoryCollectionViewCell"
    let requestCellIdentifier: String = "RequestListCollectionViewCell"
    
    let categoryArray: [String] = ["전체", "연애", "진로", "심리", "인간관계", "자존감"]
    
    // reponse model
    // 실시간 요청 목록
    var matches: Matches?
    var matchesData: MatchesData?
    var matchesDataClass: MatchesDataClass?
    var matchesRow: [MatchesRow]?
    
    // titmer
    var timer = [Int: Timer]()
    
    // MARK: - IBOutlet
    // default
    @IBOutlet weak var defaultView: UIView!
    @IBOutlet weak var editProfileView: CustomView!
    
    // recommand stack view
    @IBOutlet weak var recommandStackView: UIStackView!
    @IBOutlet weak var tagLabel: CustomLabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var recommandImageView: UIImageView!
    
    @IBOutlet weak var refreshButton: UIButton!
    
    // request.count > 0
    @IBOutlet weak var requestView: UIView!
    
    // realtime / reserve
    @IBOutlet weak var realtimeButtonView: UIStackView!
    @IBOutlet weak var realtimeButton: UIButton!
    @IBOutlet weak var realtimeImageView: UIImageView!
    
    @IBOutlet weak var reserveButtonView: UIStackView!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var reserveImageView: UIImageView!
    
    // category collection view
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    // count label
    @IBOutlet weak var countLabel: UILabel!
    
    // request collection view
    @IBOutlet weak var requestCollectionView: UICollectionView!
    
    // MARK: - IBAction
    @IBAction func tappedRefreshButton(_ sender: Any) {
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // navigation hide
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // 실시간 요청 목록 GET 통신
        postRealtimeMatches()
        
        // 초기에 실시간 화면 먼저
        reserveImageView.image = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // collectionView delegate, datasource
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        requestCollectionView.delegate = self
        requestCollectionView.dataSource = self
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // navibar hidden false
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Methods
    // 윌스너 실시간 요청 리스트
    // POST 통신
    func postRealtimeMatches() {
        WillsonerConcernServices.shared.postRealtimeMathes(categoryIndex: 0) { matches in
            self.matches = matches
            self.matchesData = self.matches?.data
            self.matchesDataClass = self.matchesData?.matches
            self.matchesRow = self.matchesDataClass?.rows
            print("================")
            print("실시간 요청 목록 통신 성공")
            
            /*
            var rows: [MatchesRow] = []
            for row in self.matchesDataClass!.rows {
                if row.status == "init" {
                    rows.append(row)
                }
            }
            self.matchesRow = rows
            */
            
            if let count = self.matchesRow?.count {
                if count == 0 {
                    // 0개 - default
                    self.defaultView.isHidden = false
                    self.requestView.isHidden = true
                } else {
                    // > 0 - request
                    self.defaultView.isHidden = true
                    self.requestView.isHidden = false
                    self.countLabel.text = "\(count)개"
                    self.reloadInputViews()
                    self.requestCollectionView.reloadData()
                }
            } else {
                // 0개 - default
                self.defaultView.isHidden = false
                self.requestView.isHidden = true
            }
        }
    }
    
    // timer
    @objc func runScheduledTask(_ runningTimer: Timer) {
        let dict = runningTimer.userInfo as? [String: UILabel]
        let timerFormatter = DateFormatter()
        
        if let label: UILabel = (dict?["cell"]) {
            label.text = ""
            for row in matchesRow! {
                if row.status == "init" {
                    if let timerCount = matchesRow?[label.tag].concern.timer {
                        let date = Date(timeIntervalSince1970: TimeInterval(timerCount / 1000))
                        var remainingSeconds: Int = Int(date.timeIntervalSinceNow)
                        remainingSeconds -= 1
                        if remainingSeconds > 0 {
                            label.text = "\(remainingSeconds / 60):\(remainingSeconds % 60)"
                            timerFormatter.dateFormat = "mm:ss"
                            if let formattime = timerFormatter.date(from:label.text ?? "") {
                                label.text = "\(timerFormatter.string(from: formattime))"
                            }
                        }
                        else if remainingSeconds == 0 {
                            runningTimer.invalidate()
                            requestCollectionView.reloadData()
                        }
                    } else {
                        print("timerCount 할당 오류")
                        runningTimer.invalidate()
                        requestCollectionView.reloadData()
                    }
                }
            }
        }
    }
}

extension HelperRequestViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            
        } else if collectionView == requestCollectionView {
            for row in matchesRow! {
            if row.status == "init" {
                guard let vc: HelperDetailRequestViewController = UIStoryboard(name: "HelperRequest", bundle: nil).instantiateViewController(withIdentifier: "HelperDetailRequestViewController") as? HelperDetailRequestViewController else {
                    print("HelperDetailRequestViewController 할당 오류")
                    return
                }
                guard let matchIndex = matchesRow?[indexPath.item].idx else {
                    print("matchesData?.rows[indexPath.item].idx 할당 오류")
                    return
                }
                vc.matchIndex = matchIndex
                
                // timer
                // 타이머에 따라서
                guard let timerCount = matchesRow?[indexPath.item].concern.timer else {
                    print("timerCount 할당 오류")
                    return
                }
                let date = Date(timeIntervalSince1970: TimeInterval(timerCount / 1000))
                let remainingSeconds: Int = Int(date.timeIntervalSinceNow)
                if remainingSeconds > 0 {
                    vc.remainingSeconds = remainingSeconds
                    vc.hidesBottomBarWhenPushed = true
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                }
            }
        }
    }
}

extension HelperRequestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categoryArray.count
        } else if collectionView == requestCollectionView {
            guard let count = matchesRow?.count else {
                print("machesData.count 할당 오류")
                return 0
            }
            return count
        } else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == categoryCollectionView {
            guard let cell: AskerHomeRecommandCategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellIdentifier, for: indexPath) as? AskerHomeRecommandCategoryCollectionViewCell else {
                print("category collection cell 할당 오류")
                return UICollectionViewCell()
            }
            
            if indexPath.item == 0 {
                cell.label.textColor = #colorLiteral(red: 0.06666666667, green: 0.5019607843, blue: 1, alpha: 1)
                cell.bgView.layer.borderColor = #colorLiteral(red: 0.06666666667, green: 0.5019607843, blue: 1, alpha: 1)
            } else {
                cell.label.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                cell.bgView.layer.borderColor = #colorLiteral(red: 0.937254902, green: 0.937254902, blue: 0.937254902, alpha: 1)
            }
            cell.label.text = categoryArray[indexPath.item]
            
            return cell
            
        } else if collectionView == requestCollectionView {
            guard let cell: RequestListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: requestCellIdentifier, for: indexPath) as? RequestListCollectionViewCell else { return UICollectionViewCell() }
            
            // 닉네임
            if let name = matchesRow?[indexPath.item].concern.asker.nickname {
                cell.nameLabel.text = name
            } else {
                print("matchesData?.rows[indexPath.item].concern.asker.nickname 할당 오류")
                cell.nameLabel.text = ""
            }
            
            // 나이 / 성별
            if let age = matchesRow?[indexPath.item].concern.asker.age {
                if let gender = matchesRow?[indexPath.item].concern.asker.gender {
                    cell.sortingLabel.text = "\(age) / \(gender)"
                } else {
                    cell.sortingLabel.text = "\(age)"
                }
            } else {
                cell.sortingLabel.text = ""
            }
            
            // 카테고리
            if let category = matchesRow?[indexPath.item].concern.subcategory.category.name {
                cell.categoryLabel.text = category
            } else {
                print("matchesData?.rows[indexPath.item].concern.subcategory.category 할당 오류")
                cell.categoryLabel.text = ""
            }
            
            // 서브 카테고리
            guard let subCategory = matchesRow?[indexPath.item].concern.subcategory.name else {
                print("matchesData?.rows[indexPath.item].concern.subcategory.name 할당 오류")
                return UICollectionViewCell()
            }
            cell.detailCategoryLabel.text = "#\(subCategory)"
            
            // 내용
            guard let content = matchesRow?[indexPath.item].concern.content else {
                print("matchesData?.rows[indexPath.item].concern.content 할당 오류")
                return UICollectionViewCell()
            }
            cell.detailLabel.text = content
            
            // 해시태그
            var personality = ""
            guard let feelings = matchesRow?[indexPath.item].concern.feelings else {
                print("matchesData?.rows[indexPath.item].concern.feelings 할당 오류")
                return UICollectionViewCell()
            }
            for feeling in feelings {
                personality += "#\(feeling.name) "
            }
            cell.hashtagLabel.text = personality
            
            // 타이머
            cell.timeLabel.tag = indexPath.item
            let t: Timer = timer[indexPath.item] ?? Timer()
            t.invalidate()
            for row in matchesRow! {
                if row.status == "init" {
                    timer[indexPath.item] = (Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.runScheduledTask), userInfo: ["cell": cell.timeLabel], repeats: true))
                } else if row.status == "waiting" {
                    // 카테고리
                    cell.categoryLabel.textColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1)
                    // 서브 카테고리
                    cell.detailCategoryLabel.textColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1)
                    // 내용
                    cell.detailLabel.textColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1)
                    // 해시태그
                    cell.hashtagLabel.textColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1)
                    // 타이머 label
                    cell.timeLabel.text = "질문자의 확정을 기다리는 중 입니다 …"
                }
            }
            return cell
            
        } else { return UICollectionViewCell() }
    }
}

extension HelperRequestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == categoryCollectionView {
            guard let cell: AskerHomeRecommandCategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCellIdentifier, for: indexPath) as? AskerHomeRecommandCategoryCollectionViewCell else {
                print("category collection cell 할당 오류")
                return CGSize(width: 0, height: 0)
            }
            
            cell.label.sizeToFit()
            
            return CGSize(width: cell.label.frame.width + 24, height: 31)
        } else if collectionView == requestCollectionView {
            return CGSize(width: UIScreen.main.bounds.width, height: 308)
        } else { return CGSize(width: 0, height: 0) }
    }
}
