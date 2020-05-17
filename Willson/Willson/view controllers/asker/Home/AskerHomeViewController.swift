//
//  AskerHomeViewController.swift
//  Willson
//
//  Created by JHKim on 15/09/2019.
//

import UIKit
import Kingfisher

class AskerHomeViewController: UIViewController {
    
    // MARK: - properties
    // 타이머
    var reloadTimer = Timer()
    
    // 질문자 메인 response model
    var askerMain: AskerMain?
    var landings: [Landing]?
    var subcategories: [IdxData]?
    var reviews: Reviews?
    var reviewsRows: [Row]?
    var interviews: [Interview]?
    var stories: [Story]?
    
    // willsoner response model
    var willsoners: AskerMainWillsoner?
    var willsonersData: [AskerMainWillsonerData]?
    
    // cell Identifier
    // 당신의 고민은 무엇인가요?
    let requestConcerncellIdentifier: String = "AskerHomeRequestConcernCollectionViewCell"
    // 주제별 고민
    let 주제별고민cellIdentifier: String = "AskerHomeCategoryConcernCollectionViewCell"
    
    let 주제별고민imageArray: [String] = ["icHeartNavy", "icBookNavy", "icSproutNavy"]
    let 주제별고민titleArray: [String] = ["연애", "진로", "자존감"]
    
    // 추천 윌스너들
    let recommandCategoryCellIdentifier: String = "AskerHomeRecommandCategoryCollectionViewCell"
    let recommandWillsonerCellIentifier: String = "AskerHomeRecommandWillsonerCollectionViewCell"
    
    // 선택된 카테고리
    var categoryIndex: Int = 0
    
    // 후기 인터뷰
    let interviewCellIdentifier: String = "AskerHomeInterviewCollectionViewCell"
    
    // 질문자 후기
    let reviewCellIdentifier: String = "AskerHomeReviewCollectionViewCell"
    
    // 날짜 형식 yy.MM.dd
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        return formatter
    }()
    
    //날짜 형식을 yyyy년 MM월 dd일로 지정
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        return formatter
    }()
    
    // 윌스너 이야기
    let willsonerStoryCellIdentifier: String = "AskerHomeWillsonerStoryCollectionViewCell"
    
    // MARK: - IBOutlet
    // collection view
    // 당신의 고민은 무엇인가요?
    @IBOutlet weak var concernCollectionView: UICollectionView!
    @IBOutlet weak var concernPageControl: UIPageControl!
    
    // 주제별 고민
    @IBOutlet weak var 주제별고민collectionView: UICollectionView!
    
    // 추천 윌스너들
    @IBOutlet weak var recommandCategoryCollectionView: UICollectionView!
    @IBOutlet weak var recommandWillsonerCollectionView: UICollectionView!
    
    // 후기 인터뷰
    @IBOutlet weak var interviewCollectionView: UICollectionView!
    
    // 질문자 후기
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    
    @IBOutlet weak var moreReviewButton: UIButton!
    
    // 윌스너 이야기
    @IBOutlet weak var willsonerStoryCollectionView: UICollectionView!
    
    // MARK: - IBAction
    // 헬퍼 모드로 전환
    @IBAction func tappedChangeModeButton(_ sender: Any) {
        guard let vc = UIStoryboard(name: "HelperTabbar", bundle: nil).instantiateViewController(withIdentifier: "HelperTabbarController") as? UITabBarController else { return }
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func tappedMoreReviewButton(_ sender: Any) {
    }
    
    /*
    // 임시 버튼 - 결제 화면으로 가기
    @IBAction func tappedGoToPay(_ sender: Any) {
        let vc = UIStoryboard(name: "AskerPay", bundle: nil).instantiateViewController(withIdentifier: "AskerPayNavi")
        self.present(vc, animated: true, completion: nil)
    }
    
    // 임시 버튼 - 캘린더 화면으로 가기
    @IBAction func tappedGoToCalendar(_ sender: Any) {
        let vc = UIStoryboard(name: "AskerConcernList", bundle: nil).instantiateViewController(withIdentifier: "ConcernListSelectDateTimeViewController")
        let navi = UINavigationController.init(rootViewController: vc)
        navi.modalPresentationStyle = .fullScreen
        self.present(navi, animated: true, completion: nil)
    }
    */
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // GET 질문자 메인
        getMain()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collection view
        // 당신의 고민은 무엇인가요?
        concernCollectionView.delegate = self
        concernCollectionView.dataSource = self
        
        concernPageControl.transform.scaledBy(x: 4, y: 4)
        
        // 주제별 고민
        주제별고민collectionView.delegate = self
        주제별고민collectionView.dataSource = self
        
        // 추천 윌스너들
        // recommand category collectionView delegate, datasource
        recommandCategoryCollectionView.delegate = self
        recommandCategoryCollectionView.dataSource = self
        
        // recommand helper collection view delegate, datasource
        let recommandWillsonerLayout = recommandWillsonerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        recommandWillsonerLayout.minimumLineSpacing = 0
        
        recommandWillsonerCollectionView.delegate = self
        recommandWillsonerCollectionView.dataSource = self
        recommandWillsonerCollectionView.decelerationRate = .fast
        
        // 후기 인터뷰
        let interviewLayout = interviewCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        interviewLayout.minimumLineSpacing = 0
        
        interviewCollectionView.delegate = self
        interviewCollectionView.dataSource = self
        interviewCollectionView.decelerationRate = .fast
        
        // 질문자 후기
        // review collection view delegate, datasource
        let reviewLayout = reviewCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        reviewLayout.minimumLineSpacing = 0
        
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        reviewCollectionView.decelerationRate = .fast
        
        // 윌스너 이야기
        // helper story collection view delegate, datasource
        let willsonerStoryLayout = interviewCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        willsonerStoryLayout.minimumLineSpacing = 0
        
        willsonerStoryCollectionView.delegate = self
        willsonerStoryCollectionView.dataSource = self
        willsonerStoryCollectionView.decelerationRate = .fast
        
        // helper story timer
        //        reloadTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(scrollAutomatically(_:)), userInfo: nil, repeats: true)
    }
    
    // MARK: - Methods
    // 상담신청하기 view tap gesture
    @objc func showConcernList(_ gesture: UITapGestureRecognizer) {
        let vc = UIStoryboard(name: "AskerConcernList", bundle: nil).instantiateViewController(withIdentifier: "ConcernListNavigationController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // #selector - reload timer
    /*
    @objc func scrollAutomatically(_ timer: Timer) {
        if let collection = willsonerStoryCollectionView {
            for cell in collection.visibleCells {
                let indexPath: IndexPath = collection.indexPath(for: cell) ?? IndexPath(row: 0, section: 0)
                if(indexPath.row < helperStoryTitleArray.count - 1) {
                    let visibleIndex: IndexPath = IndexPath.init(row: indexPath.row + 1, section: indexPath.section)
                    collection.scrollToItem(at: visibleIndex, at: .right, animated: true)
                }
                else {
                    let visibleIndex: IndexPath = IndexPath.init(row: 0, section: indexPath.section)
                    collection.scrollToItem(at: visibleIndex, at: .left, animated: true)
                }
            }
        }
    }
     */
    
    func getMain() {
        AskerMainServices.shared.getAskerMain() { askerMain in
            self.askerMain = askerMain
            self.landings = self.askerMain?.landings
            self.subcategories = self.askerMain?.subcategories
            self.reviews = self.askerMain?.reviews
            self.reviewsRows = self.reviews?.rows
            self.interviews = self.askerMain?.interviews
            self.stories = self.askerMain?.stories
            print("==================")
            print("질문자 메인 통신 성공 !")
//            print("askerMain: \(String(describing: self.askerMain))")
            
            self.concernCollectionView.reloadData()
            self.주제별고민collectionView.reloadData()
            self.recommandCategoryCollectionView.reloadData()
            self.interviewCollectionView.reloadData()
            self.reviewCollectionView.reloadData()
            guard let count = self.reviewsRows?.count else {
                print("리뷰 보러가기 count 할당 오류")
                return
            }
            self.moreReviewButton.setTitle("\(count)개의 리뷰 보러가기", for: .normal)
            self.willsonerStoryCollectionView.reloadData()
        }
        AskerMainServices.shared.getWillsoners(subcategoryIndex: categoryIndex) { willsoners in
            self.willsoners = willsoners
            self.willsonersData = self.willsoners?.data
            
            print("==============")
            print("질문자 추천 윌스너들 통신 성공 !")
//            print("askerMainWillsoner: \(String(describing: self.willsonersData))")
            self.recommandWillsonerCollectionView.reloadData()
        }
    }
    
    @objc func tappedRequestConcernView(_ tapGesture: UITapGestureRecognizer) {
         print("tapped RequestConcernView!")
        
        let vc = UIStoryboard(name: "AskerConcernList", bundle: nil).instantiateViewController(withIdentifier: "ConcernListNavigationController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
     }
}

// MARK: - UIScrollViewDelegate
extension AskerHomeViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == concernCollectionView {
            let page = Int(targetContentOffset.pointee.x / scrollView.frame.width)
            concernPageControl.currentPage = page
            print("scrollView (concernCollectionView) currentPage: \(page)")
        } else if scrollView == recommandWillsonerCollectionView || scrollView == interviewCollectionView || scrollView == willsonerStoryCollectionView {
            // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
            let cellWidth: CGFloat = 288
            let insetX = (UIScreen.main.bounds.width - cellWidth) / 2.0
            
            // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
            // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
            let page: CGFloat = targetContentOffset.pointee.x / cellWidth
            let roundedPage = round(page)
            
            targetContentOffset.pointee = CGPoint(x: roundedPage * cellWidth - insetX + 22, y: -scrollView.contentInset.top)
        } else if scrollView == reviewCollectionView {
            // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
            let cellWidth: CGFloat = 336
            let insetX = (UIScreen.main.bounds.width - cellWidth) / 2.0
            
            // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
            // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
            let page: CGFloat = targetContentOffset.pointee.x / cellWidth
            let roundedPage = round(page)
            
            targetContentOffset.pointee = CGPoint(x: roundedPage * cellWidth - insetX + 22, y: -scrollView.contentInset.top)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension AskerHomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didUpdateFocusIn context: UICollectionViewFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        if collectionView == willsonerStoryCollectionView {
            if let nextFocusedIndexPath = context.nextFocusedIndexPath {
                if (!collectionView.isScrollEnabled) {
                    collectionView.scrollToItem(at: nextFocusedIndexPath, at: .centeredHorizontally, animated: true)
                }
            }
        }
    }
}

// MARK: - UICollectionViewDataSource
extension AskerHomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // 당신의 고민은 무엇인가요?
        if collectionView == concernCollectionView {
            guard let count = landings?.count else {
                print("[랜딩]landings count 할당 오류")
                return 0
            }
            return count
        }
            // 주제별 고민
        else if collectionView == 주제별고민collectionView {
            return 주제별고민titleArray.count
        }
            // 추천 윌스너들
        else if collectionView == recommandCategoryCollectionView {
            guard let count = subcategories?.count else {
                print("[추천 윌스너들 - 카테고리] subcategories count 할당 오류")
                return 0
            }
            return count
        } else if collectionView == recommandWillsonerCollectionView {
            guard let count = willsonersData?.count else {
                print("[추천 윌스너들 - 윌스너] willsonersData count 할당 오류")
                return 0
            }
            return count
        }
            // 후기 인터뷰
        else if collectionView == interviewCollectionView {
            guard let count = interviews?.count else {
                print("[후기 인터뷰] interviews count 할당 오류")
                return 0
            }
            return count
        }
            // 질문자 후기
        else if collectionView == reviewCollectionView {
            guard let count = reviewsRows?.count else {
                print("[질문자 후기] reviewsRows count 할당 오류")
                return 0
            }
            return count
        }
        // 윌스너의 이야기
        else if collectionView == willsonerStoryCollectionView {
            guard let count = stories?.count else {
                print("[윌스너의 이야기] stories count 할당 오류")
                return 0
            }
            return count
        }
        else { return 0 }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // 당신의 고민은 무엇인가요?
        if collectionView == concernCollectionView {
            guard let cell: AskerHomeRequestConcernCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: requestConcerncellIdentifier, for: indexPath) as? AskerHomeRequestConcernCollectionViewCell else {
                print("[랜딩] collection cell 할당 오류")
                return UICollectionViewCell()
            }
            
            // 랜딩 텍스트
            guard let title = landings?[indexPath.item].copy else {
                print("[랜딩] 카피 할당 오류")
                return UICollectionViewCell()
            }
            cell.titleLabel.text = title
            
            // 랜딩 이미지
            guard let urlString = landings?[indexPath.item].pic else {
                print("[랜딩] 이미지 url 할당 오류")
                return UICollectionViewCell()
            }
            let url = URL(string: urlString)
            cell.imageView.kf.setImage(with: url)
            
            // 버튼 텍스트
            guard let buttonText = landings?[indexPath.item].btn else {
                print("[랜딩] 버튼 텍스트 할당 오류")
                return UICollectionViewCell()
            }
            cell.buttonLabel.text = buttonText
            
            // 버튼 탭 제스처 추가
            let requestConcernTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedRequestConcernView(_:)))
            cell.requestConcernButtonView.addGestureRecognizer(requestConcernTapGesture)
            
            return cell
        }
        // 주제별 고민
        else if collectionView == 주제별고민collectionView {
            guard let cell: AskerHomeCategoryConcernCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: 주제별고민cellIdentifier, for: indexPath) as? AskerHomeCategoryConcernCollectionViewCell else {
                print("[주제별 고민] collection cell 할당 오류")
                return UICollectionViewCell()
            }
            
            // 카테고리 이미지
            cell.imageView.image = UIImage(named: 주제별고민imageArray[indexPath.item])
            // 카테고리 텍스트
            cell.label.text = 주제별고민titleArray[indexPath.item]
            
            return cell
        }
        // 추천 월스너들
        else if collectionView == recommandCategoryCollectionView {
            guard let cell: AskerHomeRecommandCategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: recommandCategoryCellIdentifier, for: indexPath) as? AskerHomeRecommandCategoryCollectionViewCell else {
                print("[추천 윌스너들 - 카테고리] collection cell 할당 오류")
                return UICollectionViewCell()
            }
            
            // 카테고리 텍스트
            // 선택된 셀
            if indexPath.item == categoryIndex {
                cell.bgView.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.5019607843, blue: 1, alpha: 1) // 배경 색
                cell.label.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // 글자 색
            } else {
                cell.bgView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1) // 배경 색
                cell.label.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1) // 글자 색
            }
            guard let category = subcategories?[indexPath.item].name else {
                print("[추천 윌스너들 - 카테고리] category name 할당 오류")
                return UICollectionViewCell()
            }
            cell.label.text = category
            
            return cell
        }
        else if collectionView == recommandWillsonerCollectionView {
            guard let cell: AskerHomeRecommandWillsonerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: recommandWillsonerCellIentifier, for: indexPath) as? AskerHomeRecommandWillsonerCollectionViewCell else {
                print("[추천 윌스너들] willsoner 할당 오류")
                return UICollectionViewCell()
            }
            
            // 윌스너 이미지
            if let urlString = willsonersData?[indexPath.item].image?.pic  {
                let url = URL(string: urlString)
                cell.willsonerImageView.kf.setImage(with: url)
            } else {
                print("[추천 윌스너들] 윌스너 이미지 url 할당 오류")
                cell.willsonerImageView.image = UIImage()
            }
            
            // 윌스너 닉네임
            guard let nickname = willsonersData?[indexPath.item].asker.nickname else {
                print("[추천 윌스너들] 윌스너 닉네임 할당 오류")
                return UICollectionViewCell()
            }
            cell.willsonerNicknameLabel.text = nickname
            
            // 윌스너 나이 / 성별
            guard let age = willsonersData?[indexPath.item].asker.age else {
                print("[추천 윌스너들] 윌스너 나이 할당 오류")
                return UICollectionViewCell()
            }
            guard let gender = willsonersData?[indexPath.item].asker.gender else {
                print("[추천 윌스너들] 윌스너 성별 할당 오류")
                return UICollectionViewCell()
            }
            cell.willsonerAgeAndGenderLabel.text = "\(age) / \(gender)"
            
            // 카테고리
            guard let category = willsonersData?[indexPath.item].subcategories[0].name else {
                print("[추천 윌스너들] 카테고리 할당 오류")
                return UICollectionViewCell()
            }
            cell.categoryLabel.text = category
            
            // 해쉬태그
            guard let keywords = willsonersData?[indexPath.item].keywords else {
                print("[추천 윌스너들] 키워드 할당 오류")
                return UICollectionViewCell()
            }
            var hashtag = ""
            for keyword in keywords {
                hashtag += "#\(keyword.name)\n"
            }
            cell.hashtagLabel.numberOfLines = keywords.count
            cell.hashtagLabel.text = hashtag
            
            // 내용
            guard let content = willsonersData?[indexPath.item].experience else {
                print("[추천 윌스너들] 키워드 할당 오류")
                return UICollectionViewCell()
            }
            cell.contentLabel.text = content
            
            // 별점
            guard let rate = willsonersData?[indexPath.item].avgRating else {
                print("[추천 윌스너들] 키워드 할당 오류")
                return UICollectionViewCell()
            }
            cell.rateLabel.text = rate
//            let viewWidth = starStackView.frame.size.width / 10
            
            let rateValue = (rate as NSString).doubleValue
            let divideRating = Int(rateValue)
            var oddRating = Int(rateValue * 2) % 2
            
            var starImage = UIImage(named: "icStarLineGray")
            for (index, subview) in cell.starStackView.arrangedSubviews.enumerated() {
                if let imageSubview = subview as? UIImageView {
                    if (index < divideRating) {
                        starImage = UIImage(named: "icStarSmallBlue")
                    } else if (index >= divideRating && oddRating == 1) {
                        starImage = UIImage(named: "icStarHalfBlue")
                        oddRating = 0
                    } else {
                        starImage = UIImage(named: "icStarLineGray")
                    }
                    imageSubview.image = starImage
                }
            }
            
            return cell
        }
        // 후기 인터뷰
        else if collectionView == interviewCollectionView {
            guard let cell: AskerHomeInterviewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: interviewCellIdentifier, for: indexPath) as? AskerHomeInterviewCollectionViewCell else {
                print("[후기 인터뷰] cell 할당 오류")
                return UICollectionViewCell()
            }
            
            // 이미지
            if let urlString = interviews?[indexPath.item].image {
                let url = URL(string: urlString)
                cell.imageView.kf.setImage(with: url)
            } else {
                print("[후기 인터뷰] 이미지 url 할당 오류")
                cell.imageView.image = UIImage()
            }
            
            // 제목
            if let title = interviews?[indexPath.item].category.name {
                cell.titleLabel.text = title
            } else {
                cell.titleLabel.text = ""
            }
            
            // 내용
            if let content = interviews?[indexPath.item].title {
                cell.contentLabel.text = content
            } else {
                cell.contentLabel.text = ""
            }
            
            return cell
        }
        // 질문자 후기
        else if collectionView == reviewCollectionView {
            guard let cell: AskerHomeReviewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellIdentifier, for: indexPath) as? AskerHomeReviewCollectionViewCell else {
                print("[질문자 후기] cell 할당 오류")
                return UICollectionViewCell()
            }
            
            // 제목
            if let title = reviewsRows?[indexPath.item].title {
                cell.titleLabel.text = title
            } else {
                cell.titleLabel.text = ""
            }
            
            // 날짜
            if let dateString = reviewsRows?[indexPath.item].date {
                if let date = dateFormatter1.date(from: dateString) {
                    let dateLabelText = dateFormatter2.string(from: date)
                    cell.dateLabel.text = dateLabelText
                } else {
                    print("[질문자 후기] dateString 할당 오류")
                    cell.dateLabel.text = dateString
                }
            } else {
                cell.dateLabel.text = ""
            }
            
            // 내용
            if let content = reviewsRows?[indexPath.item].content {
                cell.contentLabel.text = content
            } else {
                cell.contentLabel.text = ""
            }
            
            // 별점
            if let rate = reviewsRows?[indexPath.item].rating {
                cell.rateLabel.text = "\(rate)"
            } else {
                cell.rateLabel.text = ""
            }
            
            return cell
        }
        // 윌스너의 이야기
        else if collectionView == willsonerStoryCollectionView {
            guard let cell: AskerHomeWillsonerStoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: willsonerStoryCellIdentifier, for: indexPath) as? AskerHomeWillsonerStoryCollectionViewCell else {
                print("[윌스너의 이야기] Cell 할당 오류")
                return UICollectionViewCell()
            }
            
            // 이미지
            if let urlString = stories?[indexPath.item].image {
                let url = URL(string: urlString)
                cell.imageView.kf.setImage(with: url)
            } else {
                print("[윌스너의 이야기] 이미지 url 할당 오류")
                cell.imageView.image = UIImage()
            }
            
            // 제목
            if let title = stories?[indexPath.item].title {
                cell.titleLabel.text = title
            } else {
                cell.titleLabel.text = ""
            }
            
            // 작가
            if let author = stories?[indexPath.item].author {
                cell.authorLabel.text = author
            } else {
                cell.authorLabel.text = ""
            }
            
            // 좋아요 수
            if let likeCount = stories?[indexPath.item].likeCnt {
                cell.countLabel.text = "\(likeCount)"
            } else {
                cell.countLabel.text = ""
            }
            
            // 좋아요 버튼 제어
            if let likeFlag = stories?[indexPath.item].likes {
                if likeFlag {
                    cell.heartButton.isSelected = true
                } else {
                    cell.heartButton.isSelected = false
                }
            } else {
                cell.heartButton.isSelected = false
            }
            
            return cell
        }
        else { return UICollectionViewCell() }
    }
}

extension AskerHomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        // 당신의 고민은 무엇인가요?
        if collectionView == concernCollectionView {
            return CGSize(width: UIScreen.main.bounds.width, height: 440)
        }
        // 주제별 고민
        else if collectionView == 주제별고민collectionView {
            let size = UIScreen.main.bounds.width / 3
            return CGSize(width: size, height: size)
        }
        // 추천 윌스너들
        else if collectionView == recommandCategoryCollectionView {
            guard let cell: AskerHomeRecommandCategoryCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: recommandCategoryCellIdentifier, for: indexPath) as? AskerHomeRecommandCategoryCollectionViewCell else {
                print("sizeForItemAt: [추천 윌스너들 - 카테고리] cell 할당 오류")
                return CGSize(width: 0, height: 0)
            }
            guard let category = subcategories?[indexPath.item].name else {
                print("[추천 윌스너들 - 카테고리] category name 할당 오류")
                return CGSize(width: 0, height: 0)
            }
            cell.label.text = category
            cell.label.sizeToFit()
            
            return CGSize(width: cell.label.frame.width + 34, height: 50)
        }
        else if collectionView == recommandWillsonerCollectionView {
            return CGSize(width: 288, height: 427)
        }
        // 후기 인터뷰
        else if collectionView == interviewCollectionView {
            return CGSize(width: 288, height: 300)
        }
        // 질문자 후기
        else if collectionView == reviewCollectionView {
            return CGSize(width: 336, height: 194)
        }
        // 윌스너의 이야기
        else if collectionView == willsonerStoryCollectionView {
            return CGSize(width: 288, height: 357)
        }
        else { return CGSize(width: 0, height: 0) }
    }
}
