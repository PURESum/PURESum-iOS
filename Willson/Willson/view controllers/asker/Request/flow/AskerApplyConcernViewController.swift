//
//  AskerApplyConcernViewController.swift
//  Willson
//
//  Created by JHKim on 2020/02/09.
//

import UIKit

class AskerApplyConcernViewController: UIViewController {

    // MARK: - properties
    // 고민 인덱스
    var concernIndex: Int?
    
    // 고민에 대한 윌스너 매치 목록 response model
    var concernMatch: ConcernMatch?
    var concernMatchRows: [ConcernMatchRows]?
    
    // collectionview cell identifier
    let cellIdentifier: String = "RequestConcernCollectionViewCell"
    let headerViewIdentifier: String = "RequestConcernHeaderCollectionReusableView"
    let footerViewIdentifier: String = "RequestConcernFooterCollectionReusableView"
    
    let defaultCellIdentifier: String = "RequestDefaultCollectionViewCell"
    
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
        guard let concernIndex: Int = self.concernIndex else {
            print("getWillsonerList(): concernIndex 할당 오류")
            return
        }
        
        AskerConcernServices.shared.getWillsonerList(concernIndex: concernIndex) { concernMatch in
            self.concernMatch = concernMatch
            self.concernMatchRows = self.concernMatch?.data
            
            print("==================")
            print("재히 고민 리스트 통신 성공 !")
            print(self.concernMatch)
            
            self.countLabel.text = "3"
            self.collectionView.reloadData()
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
        self.navigationController?.show(vc, sender: nil)
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
        
        return cell
    }
    
}

extension AskerApplyConcernViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 96)
    }
}
