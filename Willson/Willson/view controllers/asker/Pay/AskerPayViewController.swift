//
//  AskerPayViewController.swift
//  Willson
//
//  Created by JHKim on 15/10/2019.
//

import UIKit
import Kingfisher

class AskerPayViewController: UIViewController {

    // MARK: - properties
    let willsonerCellIdentifier: String = "AskerPayWillsonerCollectionViewCell"
    let amountCellIdentifier: String = "AskerPayAmountTableViewCell"
    
    // 고민 신청 완료 response model
    var concernIndex: Int = 0
    
    // 고민결제 response model
    var askerPay: AskerPay?
    var askerPayData: AskerPayData?
    var willsoners: [AskerPayWillsoner]?
    var tickets: [Ticket]?
    var concern: AskerPayConcern?
    
    // 상담 시간 인덱스
    var ticketIndex: Int?
    
    // MARK: - IBOutlet
    // 예상 답변자
    @IBOutlet weak var willsonerCollectionView: UICollectionView!
    
    // 상담시간 선택
    @IBOutlet var amoutTableView: UITableView!
    
    // 신청 내용
    @IBOutlet weak var categoryLabel: CustomLabel!
    @IBOutlet weak var subCategoryLabel: UILabel!
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var keywordLabel: UILabel!
    
    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedTextButton(_ sender: Any) {
        /*
        guard let vc: AskerPayMethodViewController = UIStoryboard(name: "AskerPay", bundle: nil).instantiateViewController(withIdentifier: "AskerPayMethodViewController") as? AskerPayMethodViewController else {
            print("AskerPayMethodViewController 할당 오류")
            return
        }
        
        // 값 넘기기
        vc.tickets = self.tickets
        vc.ticketIndex = self.ticketIndex
        vc.concernIndex = self.concernIndex
        
        self.navigationController?.show(vc, sender: nil)
         */
        guard let vc: AskerPayFinalViewController = UIStoryboard(name: "AskerPay", bundle: nil).instantiateViewController(withIdentifier: "AskerPayFinalViewController") as? AskerPayFinalViewController else {
            print("AskerPayFinalViewController 할당 오류")
            return
        }
        
        // 값 넘기기
        vc.tickets = self.tickets
        vc.ticketIndex = self.ticketIndex
        vc.concernIndex = self.concernIndex
        
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: false, completion: nil)
    }
    
    // MARK: - life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // back button hidden
//        self.navigationItem.hidesBackButton = true

        // collectionView delegate, dataSource
        let willsonerLayout = willsonerCollectionView.collectionViewLayout as! UICollectionViewFlowLayout
        willsonerLayout.minimumLineSpacing = 0
        willsonerCollectionView.delegate = self
        willsonerCollectionView.dataSource = self
        willsonerCollectionView.decelerationRate = .fast
        
        // tableView delegate, dataSource
        amoutTableView.delegate = self
        amoutTableView.dataSource = self
        
        amoutTableView.rowHeight = 55
        amoutTableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        amoutTableView.separatorStyle = .none
        
        // 고민결제 통신
        getPay()
        
        // 버튼 비활성화
        nextButton.isEnabled = false
    }

    // MARK: - Method
    // 고민결제
    // GET /asker/payment/:concern_idx
    func getPay() {
        AskerPayServices.shared.getPayment(concernIdx: self.concernIndex) { askerPay in
            self.askerPay = askerPay
            self.askerPayData = self.askerPay?.data
            self.willsoners = self.askerPayData?.willsoners
            self.tickets = self.askerPayData?.tickets
            self.concern = self.askerPayData?.concern
            
            print("==============")
            print("고민결제 GET 통신 성공 !")
            
            self.willsonerCollectionView.reloadData()
            self.amoutTableView.reloadData()
            self.setup신청내용()
        }
    }
    
    func setup신청내용() {
        // 카테고리
        if let category = concern?.subcategory.category.name {
            categoryLabel.text = category
        } else {
            categoryLabel.text = ""
        }
        
        // 서브 카테고리
        if let subCategory = concern?.subcategory.name {
            subCategoryLabel.text = subCategory
        } else {
            subCategoryLabel.text = ""
        }
        
        // 내용
        if let content = concern?.content {
            contentTextView.text = content
        } else {
            contentTextView.text = ""
        }
        
        // 키워드
        if let keywords = concern?.personalities {
            var keywordString = ""
            for keyword in keywords {
                keywordString += "#\(keyword.name) "
            }
            keywordLabel.text = keywordString
        } else {
            keywordLabel.text = ""
        }
        
        // 한줄 소개
        if let introduce = concern?.direction.name {
            introduceLabel.text = introduce
        } else {
            introduceLabel.text = ""
        }
        
        // 닉네임
        if let nickname = concern?.asker.nickname {
            nicknameLabel.text = nickname
        } else {
            nicknameLabel.text = ""
        }
        
        self.view.reloadInputViews()
    }
    
    func checkSelectedTicket() {
        if ticketIndex != nil {
            UserDefaults.standard.set(ticketIndex, forKey: "ticketIndex")
            print("ticket Index: \(ticketIndex ?? 0)")
            nextButton.isSelected = true
            nextButton.isEnabled = true
        } else {
            nextButton.isSelected = false
            nextButton.isEnabled = false
        }
    }
}

// MARK: - UIScrollViewDelegate
extension AskerPayViewController: UIScrollViewDelegate {
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if scrollView == willsonerCollectionView {
            // item의 사이즈와 item 간의 간격 사이즈를 구해서 하나의 item 크기로 설정.
            let cellWidth: CGFloat = 278
            let insetX = (UIScreen.main.bounds.width - cellWidth) / 2.0
            
            // targetContentOff을 이용하여 x좌표가 얼마나 이동했는지 확인
            // 이동한 x좌표 값과 item의 크기를 비교하여 몇 페이징이 될 것인지 값 설정
            let page: CGFloat = targetContentOffset.pointee.x / cellWidth
            let roundedPage = round(page)
            
            targetContentOffset.pointee = CGPoint(x: roundedPage * cellWidth - insetX + 25, y: -scrollView.contentInset.top)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension AskerPayViewController: UICollectionViewDelegate {
    
}

// MARK: - UICollectionViewDataSource
extension AskerPayViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = willsoners?.count else {
            print("willsoners count 할당 오류")
            return 0
        }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: AskerPayWillsonerCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: willsonerCellIdentifier, for: indexPath) as? AskerPayWillsonerCollectionViewCell else {
            print("[예상 답변자] cell 할당 오류")
            return UICollectionViewCell()
        }
        // 이미지
        if let urlString = willsoners?[indexPath.item].image.pic {
            let url = URL(string: urlString)
            cell.willsonerImageView.kf.setImage(with: url)
        } else {
            print("[예상 답변자] 윌스너 이미지 url 할당 오류")
            cell.willsonerImageView.image = UIImage()
        }
        
        // 닉네임
        if let nickname = willsoners?[indexPath.item].asker.nickname {
            cell.nicknameLabel.text = nickname
        } else {
            print("[예상 답변자] nickname 할당 오류")
            cell.nicknameLabel.text = ""
        }
        
        // 나이 / 성별
        if let age = willsoners?[indexPath.item].asker.age {
            if let gender = willsoners?[indexPath.item].asker.gender {
                cell.ageAndGenderLabel.text = "\(age) / \(gender)"
            } else {
                print("[예상 답변자] gender 할당 오류")
                cell.ageAndGenderLabel.text = "\(age)"
            }
        } else {
            print("[예상 답변자] age 할당 오류")
            cell.ageAndGenderLabel.text = ""
        }
        
        // 별점
        if let rate = willsoners?[indexPath.item].avgRating {
            cell.rateLabel.text = rate
        } else {
            print("[예상 답변자] rate 할당 오류")
            cell.rateLabel.text = ""
        }
        
        // 카테고리
        if let categories = willsoners?[indexPath.item].subcategories {
            var categoryString = ""
            for category in categories {
                categoryString += "#\(category.name) "
            }
            cell.categoryLabel.text = categoryString
        } else {
            print("[예상 답변자] category 할당 오류")
            cell.categoryLabel.text = ""
        }
        
        // 내용
        if let introduce = willsoners?[indexPath.item].introduction {
            cell.introduceLabel.text = introduce
        } else {
            print("[예상 답변자] introduce 할당 오류")
            cell.introduceLabel.text = ""
        }
        
        // 키워드
        if let keywords = willsoners?[indexPath.item].keywords {
            var keywordString = ""
            for keyword in keywords {
                keywordString += "#\(keyword.name) "
            }
            cell.keywordLabel.text = keywordString
        } else {
            print("[예상 답변자] keyword 할당 오류")
            cell.keywordLabel.text = ""
        }
        
        cell.layer.backgroundColor = UIColor.white.cgColor
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension AskerPayViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 278, height: 355)
    }
}

// MARK: - UITableViewDelegate
extension AskerPayViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("===========did selected row at: \(indexPath.row)===========")
        guard let idx = tickets?[indexPath.row].idx else {
            print("ticket index 할당 오류")
            return
        }
        ticketIndex = idx
        checkSelectedTicket()
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        print("===========did deSelected row at: \(indexPath.row)===========")
        checkSelectedTicket()
    }
}

// MARK: - UITableViewDataSource
extension AskerPayViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = tickets?.count else {
            print("[상담시간 선택] tickes count 할당 오류")
            return 0
        }
         return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: AskerPayAmountTableViewCell = tableView.dequeueReusableCell(withIdentifier: amountCellIdentifier, for: indexPath) as? AskerPayAmountTableViewCell else { return UITableViewCell() }
        
        // 상담권
        guard let title = tickets?[indexPath.item].type else {
            print("[상담시간 선택] ticket type 할당 오류")
            return UITableViewCell()
        }
        cell.amountLabel.text = title
        
        // 가격
        guard let price = tickets?[indexPath.item].amount else {
            print("[상담시간 선택] ticket price 할당 오류")
            return UITableViewCell()
        }
        cell.amountButton.setTitle(price, for: .normal)
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.selectionStyle = .none
        return cell
    }
}
