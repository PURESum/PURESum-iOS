//
//  AskerDetailRequestViewController.swift
//  Willson
//
//  Created by JHKim on 12/10/2019.
//

import UIKit
import Kingfisher
import Firebase
import Toast_Swift
import ObjectMapper

class AskerDetailRequestViewController: UIViewController {

    // MARK: - properties
    let reviewCellIdentifier: String = "AskerRequestReviewCollectionViewCell"
    
    // 윌스너 세부 페이지 response model
    var willsonerDetail: WillsonerDetail?
    var willsonerDetailData: WillsonerDetailData?
    var willsonerDetailMatch: WillsonerDetailMatch?
    var willsonerDetailReview: WillsonerDetailReviews?
    
    // 이전 화면에서 받아오기
    var matchIndex: Int?
    
    // 윌스너 선택 (최종 수락) response model
    var matchSuccess: MatchSuccess?
    var matchSuccessData: MatchSuccessData?
    
    // 채팅 - firestore
    var db: Firestore!
    
    let user = Auth.auth().currentUser
    
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
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageView: CustomImageView!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var ageAndGenderLabel: UILabel!
    @IBOutlet weak var imageLabel: UILabel!
    
    @IBOutlet weak var introductionLabel: UILabel!
    
    @IBOutlet weak var categoryLabel: CustomLabel!
    @IBOutlet weak var subcategoryLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var hashTagLabel: UILabel!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var countReviewLabel: UILabel!
    
    @IBOutlet weak var starStackView: UIStackView!
    
    @IBOutlet weak var star1ImageView: UIImageView!
    @IBOutlet weak var star2ImageView: UIImageView!
    @IBOutlet weak var star3ImageView: UIImageView!
    @IBOutlet weak var star4ImageView: UIImageView!
    @IBOutlet weak var star5ImageView: UIImageView!
    
    @IBOutlet weak var reviewCollectionView: UICollectionView!
    
    @IBOutlet weak var selectButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedSelectButton(_ sender: Any) {
        guard let matchIndex = self.matchIndex else {
            print("matchIndex가 nil 값을 가짐")
            return
        }
        
        // PATCH 통신
        AskerConcernServices.shared.patchMatchSuccess(matchIndex: matchIndex) { matchSuccess in
            self.matchSuccess = matchSuccess
            
            print("====================")
            print("윌스너 선택 (최종 수락) 통신 성공")
            
            // 채팅방 개설
            // room key
            guard let roomkey = self.matchSuccess?.data?.roomkey else {
                print("self.matchSuccess?.data.roomkey 할당 오류")
                return
            }
            
            // Add a new document with a generated ID
            var ref: DocumentReference? = nil
            ref = self.db.collection("chatrooms").document(roomkey).collection("chats").document("start")
            ref?.setData([
                "uid" : "start",
                "message" : "",
                "timeStamp" : FieldValue.serverTimestamp()
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                    // 토스트 띄우기
                    self.view.makeToast("실패!",
                                        duration: 3.0,
                                        position: .bottom,
                                         style: ToastStyle())
                } else {
                    print("Document added with ID: \(ref!.documentID)")
                }
            }
            
            /*
            // 토스트 띄우기
            self.view.makeToast("대화 성공!",
                                duration: 3.0,
                                position: .bottom,
                                 style: ToastStyle())
            */
            
            // 화면 이동
            guard let vc: AskerConfirmTalkViewController = UIStoryboard(name: "AskerRequest", bundle: nil).instantiateViewController(withIdentifier: "AskerConfirmTalkViewController") as? AskerConfirmTalkViewController else {
                print("AskerConfirmTalkViewController 할당 오류")
                return
            }
            
            vc.matchSuccessData = self.matchSuccessData
            
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: false)
        }
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        // 탭바 숨김 처리
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collection view delegate, datasource
        let reviewLayout = reviewCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        reviewLayout.minimumLineSpacing = 0
        
        reviewCollectionView.delegate = self
        reviewCollectionView.dataSource = self
        reviewCollectionView.decelerationRate = .fast
        
        // get 통신
        getWillsonerDetail()
        
        // firestore
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    
    // MARK: - Methods
    func getWillsonerDetail() {
        guard let matchIndex = self.matchIndex else {
            print("matchIndex가 nil 값을 가짐")
            return
        }
        AskerConcernServices.shared.getWillsonerDetail(matchIndex: matchIndex) { willsonerDetail in
            self.willsonerDetail = willsonerDetail
            self.willsonerDetailData = self.willsonerDetail?.data
            self.willsonerDetailMatch = self.willsonerDetailData?.match
            self.willsonerDetailReview = self.willsonerDetailData?.reviews
            
            print("================")
            print("윌스너 세부 페이지 통신 성공")
            
            self.setUpViews()
            self.reloadInputViews()
            self.reviewCollectionView.reloadData()
        }
    }
    
    func setUpViews() {
        // 이미지
        if let urlString = willsonerDetailMatch?.willsoner.image?.pic {
            let url = URL(string: urlString)
            imageView.kf.setImage(with: url)
        } else {
            print("setUpViews: urlString 할당 오류")
            imageView.image = UIImage()
        }
        
        
        // 닉네임
        if let nickname = willsonerDetailMatch?.willsoner.asker.nickname {
            nicknameLabel.text = nickname
        } else {
            print("setUpViews: nickname 할당 오류")
            nicknameLabel.text = ""
        }
        
        
        // 나이, 성별
        if let age = willsonerDetailMatch?.willsoner.asker.age {
            if let gender = willsonerDetailMatch?.willsoner.asker.gender {
                ageAndGenderLabel.text = "\(age) / \(gender)"
            } else {
                print("setUpViews: 성별 할당 오류")
                ageAndGenderLabel.text = "\(age)"
            }
        } else {
            print("setUpViews: 나이 할당 오류")
            ageAndGenderLabel.text = ""
        }
        
        // 이미지 타입
        if let type = willsonerDetailMatch?.willsoner.image?.name {
            imageLabel.text = type
        } else {
            print("setUpViews: 이미지 타입 할당 오류")
            imageLabel.text = ""
        }
        
        // 한줄 소개
        if let introduction = willsonerDetailMatch?.willsoner.introduction {
            introductionLabel.text = introduction
        } else {
            print("setUpViews: 한줄 소개 할당 오류")
            introductionLabel.text = ""
        }

        // 카테고리
        if let category = willsonerDetailMatch?.willsoner.subcategories[0].category.name {
            categoryLabel.text = category
        } else {
            print("setUpViews: 카테고리 할당 오류")
            categoryLabel.text = ""
        }
        
        // 세부 카테고리
        if let subcategory = willsonerDetailMatch?.willsoner.subcategories[0].name {
            subcategoryLabel.text = subcategory
        } else {
            print("setUpViews: 세부 카테고리 할당 오류")
            subcategoryLabel.text = ""
        }
        
        // 경험 (내용)
        if let content = willsonerDetailMatch?.willsoner.experience {
            contentTextView.text = content
        } else {
            print("setUpViews: 경험 내용 할당 오류")
            contentTextView.text = ""
        }
        
        // 해쉬태그
        if let keywords = willsonerDetailMatch?.willsoner.keywords {
            var keywordString = ""
            for keyword in keywords {
                keywordString = "#\(keyword.name) "
            }
            hashTagLabel.text = keywordString
        } else {
            print("setUpViews: 키워드 할당 오류")
            hashTagLabel.text = ""
        }
        
        
        // 별점
        if let rate = willsonerDetailReview?.avg {
            if rate == "NaN" {
                rateLabel.text = "0점"
            } else {
                rateLabel.text = "\(rate)점"
                let rateValue = (rate as NSString).doubleValue
                let divideRating = Int(rateValue)
                var oddRating = Int(rateValue * 2) % 2
                
                var starImage = UIImage(named: "icStarLineGray")
                for (index, subview) in starStackView.arrangedSubviews.enumerated() {
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
            }
        } else {
            print("setUpViews 별점 할당 오류")
            rateLabel.text = "0점"
        }
        
        // 후기 개수
        if let reviewCount = willsonerDetailReview?.count {
            countReviewLabel.text = "\(reviewCount)개의 후기"
        } else {
            print("setUpViews 후기 개수 할당 오류")
            countReviewLabel.text = "0개의 후기"
        }
    }
}

// MARK: - UIScrollViewDelegate
extension AskerDetailRequestViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == reviewCollectionView {
            // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
            let cellWidth: CGFloat = UIScreen.main.bounds.width
//            let insetX = (UIScreen.main.bounds.width - cellWidth) / 2.0
            
            // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
            // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
            let page: CGFloat = targetContentOffset.pointee.x / cellWidth
            let roundedPage = round(page)
            
            targetContentOffset.pointee = CGPoint(x: roundedPage * cellWidth, y: -scrollView.contentInset.top)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension AskerDetailRequestViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension AskerDetailRequestViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = willsonerDetailReview?.count else {
            print("willsonerInfo?.reviews.count 할당 오류")
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: AskerRequestReviewCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: reviewCellIdentifier, for: indexPath) as? AskerRequestReviewCollectionViewCell else { return UICollectionViewCell() }
        
        // 제목
        if let title = willsonerDetailReview?.rows?[indexPath.item].title {
            cell.titleLabel.text = title
        } else {
            print("cellForItemAt: title 할당 오류")
            cell.titleLabel.text = ""
        }
        
        // 날짜
        if let dateString = willsonerDetailReview?.rows?[indexPath.item].date {
            if let date = dateFormatter1.date(from: dateString) {
                let dateLabelText = dateFormatter2.string(from: date)
                cell.dataLabel.text = dateLabelText
            } else {
                print("[질문자 후기] dateString 할당 오류")
                cell.dataLabel.text = dateString
            }
        } else {
            cell.dataLabel.text = ""
        }
        
        // 내용
        if let content = willsonerDetailReview?.rows?[indexPath.item].content {
            cell.contentLabel.text = content
        } else {
            print("cellForItemAt: content 할당 오류")
            cell.contentLabel.text = ""
        }
        
        // 별점
        if let rate = willsonerDetailReview?.rows?[indexPath.item].rating {
            cell.rateLabel.text = "\(rate)"
        } else {
            print("cellForItemAt: rating 할당 오류")
            cell.rateLabel.text = ""
        }
        
        return cell
    }
}

extension AskerDetailRequestViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 200)
    }
}
