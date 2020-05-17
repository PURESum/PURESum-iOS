//
//  AskerRequestConcernListViewController.swift
//  Willson
//
//  Created by JHKim on 2020/01/20.
//

/*
import UIKit

class AskerRequestConcernListViewController: UIViewController {

    
    // MARK: - properties
    let cellIdentifier: String = "RequestConcernCollectionViewCell"
    let headerViewIdentifier: String = "RequestConcernHeaderCollectionReusableView"
    let footerViewIdentifier: String = "RequestConcernFooterCollectionReusableView"
    
    // 고민 목록 reponse model
    var concerns: Concerns?
    var concernsData: ConcernsData?
    
    // MARK: - IBOutlet
    @IBOutlet weak var concernListCollectionView: UICollectionView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // navibar hidden
        navigationController?.setNavigationBarHidden(true, animated: true)
        
        // collectionview delegate, datasource
        concernListCollectionView.delegate = self
        concernListCollectionView.dataSource = self
        
        // 고민 목록 GET 통신
        getconcerns()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // navibar hidden
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    // MARK: - Methods
    func getconcerns() {
        AskerListConcernsService.shared.getConcerns { concerns in
            self.concerns = concerns
            self.concernsData = self.concerns?.data
            print("===================")
            print("고민 목록 GET 통신 성공")
            
            self.concernListCollectionView.reloadData()
        }
    }
    
}

extension AskerRequestConcernListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*
        guard let navi: UINavigationController = UIStoryboard(name: "AskerTabbar", bundle: nil).instantiateViewController(withIdentifier: "AskerApplyConcernNavi") as? UINavigationController else {
            print("didSelectItemAt: AskerApplyConcernNavi 할당 오류")
            return
        }
        
        guard let parent: AskerApplyConcernViewController = UIStoryboard(name: "AskerRequest", bundle: nil).instantiateViewController(withIdentifier: "AskerApplyConcernViewController") as? AskerApplyConcernViewController else {
            print("didSelectedItemAt: AskerApplyConcernViewController 할당 오류")
            return
        }
        */
        
        guard let vc: AskerRequestWillsonerListViewController = UIStoryboard(name: "AskerRequest", bundle: nil).instantiateViewController(withIdentifier: "AskerRequestWillsonerListViewController") as? AskerRequestWillsonerListViewController else {
            print("didSelectItemAt: AskerRequestWillsonerListViewController 할당 오류")
            return
        }
        
        guard let index = concernsData?.rows[indexPath.item].idx else {
            print("concernsData?.rows[indexPath.item].idx 할당 오류")
            return
        }
        vc.index = index
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension AskerRequestConcernListViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
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
                if let count = concernsData?.count {
                    header.countLabel.text = "\(count)"
                }else {
                    print("concernsData.count 할당 오류 - dequeueReusableSupplementaryView")
                    header.countLabel.text = "0"
                }
            case 1:
                header.titleLabel.text = "예약"
                header.countLabel.text = "0"
            case 2:
                header.titleLabel.text = "완료된 고민"
                header.countLabel.text = "0"
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
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            guard let count = concernsData?.count else {
                print("concernsData.count 할당 오류 - numberOfItemsInSection")
                return 0
            }
            return count
        case 1: return 0
        case 2: return 0
        default: return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if concernsData == nil {
            return UICollectionViewCell()
        }
        guard let cell: RequestConcernCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? RequestConcernCollectionViewCell else {
            print("RequestConcernCollectionViewCell 할당 오류")
            return UICollectionViewCell()
        }
        guard let category = concernsData?.rows[indexPath.item].subcategory.category.name else {
            print("concernsData?.rows[indexPath.item].subcategory.category.name 할당 오류")
            return UICollectionViewCell()
        }
        cell.categoryLabel.text = category
        
        guard let subCategory = concernsData?.rows[indexPath.item].subcategory.name else {
            print("concernsData?.rows[indexPath.item].subcategory.name 할당 오류")
            return UICollectionViewCell()
        }
        cell.titleLabel.text = "#\(subCategory)"
        
        guard let content = concernsData?.rows[indexPath.item].content else {
            print("concernsData?.rows[indexPath.item].content 할당 오류")
            return UICollectionViewCell()
        }
        cell.contentLabel.text = content
        
        guard let personalities = concernsData?.rows[indexPath.item].personalities else {
            print("concernsData?.rows[indexPath.item].personalities 할당 오류")
            return UICollectionViewCell()
        }
        var personalitiesText = ""
        for personality in personalities {
            personalitiesText += "#\(personality.name) "
        }
        cell.hashTagLabel.text = personalitiesText
        
        return cell
    }
}

extension AskerRequestConcernListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 33)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 51)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 273)
    }
}

 */
