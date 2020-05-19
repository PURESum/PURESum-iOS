//
//  AskerApplyConcernViewController.swift
//  Willson
//
//  Created by JHKim on 2020/02/09.
//

import UIKit

class AskerApplyConcernViewController: UIViewController {

    // MARK: - properties
    // 고민에 대한 윌스너 매치 목록 response model
    var concernMatch: ConcernMatch?
    var concernMatchRows: [ConcernMatchRows]?
    
    // collectionview cell identifier
    let cellIdentifier: String = "RequestWillsonerListCollectionViewCell"
    
    // MARK: - IBOutlet
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var contentView: UIView!
    
    // default
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var applyButtonView: CustomView!
    
    
    // request
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // navibar hidden
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // 고민 목록 GET 통신
        getWillsonerList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // apply button action
        let applyButtonViewTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedApplyButtonView(_:)))
        applyButtonView.addGestureRecognizer(applyButtonViewTapGesture)
        
        // collectionview delegate, datasource
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // navibar hidden
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Methods
    private func getWillsonerList() {
        if let concernIndex: Int = UserDefaults.standard.value(forKey: "concernIndex") as? Int {
            print("getWillsonerList() - concernIndex: \(concernIndex)")
            
            AskerConcernServices.shared.getWillsonerList(concernIndex: concernIndex) { concernMatch in
                self.concernMatch = concernMatch
                self.concernMatchRows = self.concernMatch?.data
                
                print("==================")
                print("재히 고민 리스트 통신 성공 !")
                print(self.concernMatch)
                
                if let count = self.concernMatchRows?.count {
                    self.countLabel.text = "\(count)"
                    self.view.backgroundColor = .white
                    self.collectionView.isHidden = false
                    
                    self.collectionView.reloadData()
                } else {
                    // 고민 없을 때
                    self.countLabel.text = "0"
                    self.view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
                    self.collectionView.isHidden = true
                }
            }
        } else {
            // 고민 없을 때
            self.countLabel.text = "0"
            self.view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
            self.collectionView.isHidden = true
        }
        
    }
    
    // apply button action
    @objc func tappedApplyButtonView(_ gesture: UITapGestureRecognizer) {
        print("tapped RequestConcernView!")
        
        let vc = UIStoryboard(name: "AskerConcernList", bundle: nil).instantiateViewController(withIdentifier: "ConcernListNavigationController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
}

// MARK: - UICollectionViewDelegate
extension AskerApplyConcernViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc: AskerDetailRequestViewController = UIStoryboard(name: "AskerRequest", bundle: nil).instantiateViewController(withIdentifier: "AskerDetailRequestViewController") as? AskerDetailRequestViewController else {
            print("AskerDetailRequestViewController 할당 오류")
            return
        }
        guard let matchIndex = concernMatchRows?[indexPath.item].idx else {
            print("concernMatchData?.rows[indexPath.item].idx 할당 오류")
            return
        }
        vc.matchIndex = matchIndex
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AskerApplyConcernViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = concernMatchRows?.count {
            return count
        } else {
            print("numberOfItemsInSection: concernMatchRows?.count 할당 오류")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: RequestWillsonerListCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? RequestWillsonerListCollectionViewCell else {
            print("")
            return UICollectionViewCell()
        }
        
        // 이미지
        if let urlString = concernMatchRows?[indexPath.item].willsoner.image?.pic {
            let url = URL(string: urlString)
            cell.imageView.kf.setImage(with: url)
        } else {
            print("setUpViews: urlString 할당 오류")
            cell.imageView.image = UIImage()
        }
        
        guard let name = concernMatchRows?[indexPath.item].willsoner.asker.nickname else {
            print("concernMatchData?[indexPath.item].willsoner.asker.nickname 할당 오류")
            return UICollectionViewCell()
        }
        cell.nameLabel.text = name
        
        guard let age = concernMatchRows?[indexPath.item].willsoner.asker.age else {
            print("concernMatchData?[indexPath.item].willsoner.asker.age 할당 오류")
            return UICollectionViewCell()
        }
        guard let gender = concernMatchRows?[indexPath.item].willsoner.asker.gender else {
            print("concernMatchData?[indexPath.item].willsoner.asker.gender 할당 오류")
            return UICollectionViewCell()
        }
        
        cell.ageAndGenderLabel.text = "\(age) / \(gender)"
        
        guard let subCategory = concernMatchRows?[indexPath.item].willsoner.subcategories?[0].name else {
            print("concernMatchData?[indexPath.item].willsoner.subcategory.name 할당 오류")
            return UICollectionViewCell()
        }
        cell.titleLabel.text = subCategory
        
        guard let content = concernMatchRows?[indexPath.item].willsoner.experience else {
            print("concernMatchData?[indexPath.item].willsoner.experience 할당 오류")
            return UICollectionViewCell()
        }
        cell.contentLabel.text = content
        
        guard let keywords = concernMatchRows?[indexPath.item].willsoner.keywords else {
            print("concernMatchData?[indexPath.item].willsoner.keywords 할당 오류")
            return UICollectionViewCell()
        }
        var keywordString = ""
        for keyword in keywords {
            keywordString += "#\(keyword.name) "
        }
        cell.hashTagLabel.text = keywordString
        
        // 별점
        if let rate = concernMatchRows?[indexPath.item].willsoner.avgRating {
            if rate == "NaN" {
                cell.rateLabel.text = "0점"
            } else {
                cell.rateLabel.text = "\(rate)점"
            }
        }
        return cell
    }
    
}

extension AskerApplyConcernViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 96)
    }
}
