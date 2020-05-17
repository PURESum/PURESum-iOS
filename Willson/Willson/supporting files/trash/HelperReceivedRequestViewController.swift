//
//  HelperReceivedRequestViewController.swift
//  Willson
//
//  Created by JHKim on 2019/11/24.
//

/*
import UIKit

class HelperReceivedRequestViewController: UIViewController {
    
    // MARK: - properties
    let categoryCellIdentifier: String = "AskerHomeRecommandCategoryCollectionViewCell"
    let requestCellIdentifier: String = "RequestListCollectionViewCell"
    
    let categoryArray: [String] = ["전체", "연애", "진로", "심리", "인간관계", "자존감"]
    
    // reponse model
    // 실시간 요청 목록
    var matches: Matches?
    var matchesData: MatchesData?
    
    // MARK: - IBOutlet
    @IBOutlet weak var realtimeButtonView: UIStackView!
    @IBOutlet weak var realtimeButton: UIButton!
    @IBOutlet weak var realtimeImageView: UIImageView!
    
    @IBOutlet weak var reserveButtonView: UIStackView!
    @IBOutlet weak var reserveButton: UIButton!
    @IBOutlet weak var reserveImageView: UIImageView!
    
    @IBOutlet weak var categoryCollectionView: UICollectionView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var sortView: UIView!
    @IBOutlet weak var sortLabel: UILabel!
    
    @IBOutlet weak var requestCollectionView: UICollectionView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // navigation hide
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // 실시간 요청 목록 GET 통신
        getMatches()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collectionView delegate, datasource
        categoryCollectionView.delegate = self
        categoryCollectionView.dataSource = self
        
        requestCollectionView.delegate = self
        requestCollectionView.dataSource = self
        
        // 실시간 요청 목록 GET 통신
        getMatches()
        
        // 초기에 실시간 화면 먼저
        reserveImageView.image = UIImage()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // navibar hidden false
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Methods
    
    // 실시간 요청 목록
    // GET 통신
    func getMatches() {
        WillsonerListMatchesService.shared.getmatches{ matches in
            self.matches = matches
            self.matchesData = self.matches?.data
            print("================")
            print("실시간 요청 목록 통신 성공")
            
            guard let count = self.matchesData?.count else {
                print("self.matchesData?.count 할당 오류")
                return
            }
            self.countLabel.text = "\(count)개"
            self.reloadInputViews()
            self.requestCollectionView.reloadData()
        }
    }
}

extension HelperReceivedRequestViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollectionView {
            
        } else if collectionView == requestCollectionView {
            if #available(iOS 13.0, *) {
                guard let vc: HelperDetailRequestViewController = UIStoryboard(name: "HelperRequest", bundle: nil).instantiateViewController(identifier: "HelperDetailRequestViewController") as? HelperDetailRequestViewController else {
                    print("HelperDetailRequestViewController 할당 오류")
                    return
                }
                
                guard let matchIndex = matchesData?.rows[indexPath.item].idx else {
                    print("matchesData?.rows[indexPath.item].idx 할당 오류")
                    return
                }
                vc.matchIndex = matchIndex
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.show(vc, sender: nil)
            }
            else {
                // Fallback on earlier versions
            }
        }
    }
}

extension HelperReceivedRequestViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollectionView {
            return categoryArray.count
        } else if collectionView == requestCollectionView {
            guard let count = matchesData?.rows.count else {
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
            
            guard let name = matchesData?.rows[indexPath.item].concern.asker.nickname else {
                print("matchesData?.rows[indexPath.item].concern.asker.nickname 할당 오류")
                return UICollectionViewCell()
            }
            cell.nameLabel.text = name
            
            guard let category = matchesData?.rows[indexPath.item].concern.subcategory.category.name else {
                print("matchesData?.rows[indexPath.item].concern.subcategory.category 할당 오류")
                return UICollectionViewCell()
            }
            cell.categoryLabel.text = category
            
            guard let subCategory = matchesData?.rows[indexPath.item].concern.subcategory.name else {
                print("matchesData?.rows[indexPath.item].concern.subcategory.name 할당 오류")
                return UICollectionViewCell()
            }
            cell.detailCategoryLabel.text = "#\(subCategory)"
            
            guard let content = matchesData?.rows[indexPath.item].concern.content else {
                print("matchesData?.rows[indexPath.item].concern.content 할당 오류")
                return UICollectionViewCell()
            }
            cell.detailLabel.text = content
            
            var personality = ""
            guard let feelings = matchesData?.rows[indexPath.item].concern.feelings else {
                print("matchesData?.rows[indexPath.item].concern.feelings 할당 오류")
                return UICollectionViewCell()
            }
            for feeling in feelings {
                personality += "#\(feeling.name) "
            }
            cell.hashtagLabel.text = personality
            
            return cell
            
        } else { return UICollectionViewCell() }
    }
    
}

extension HelperReceivedRequestViewController: UICollectionViewDelegateFlowLayout {
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
 */
