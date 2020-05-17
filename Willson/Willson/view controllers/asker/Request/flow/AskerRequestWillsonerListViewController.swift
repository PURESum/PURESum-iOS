//
//  AskerRequestWillsonerListViewController.swift
//  Willson
//
//  Created by JHKim on 2020/01/30.
//

import UIKit

class AskerRequestWillsonerListViewController: UIViewController {
    
    // MARK: - properties
    let headerIdentitier: String = "WillsonerListHeaderCollectionReusableView"
    let cellIdentifier: String = "RequestWillsonerListCollectionViewCell"
    let footerIdentifier: String = "WillsonerListFooterCollectionReusableView"
    
    // index - 이전 화면에서 받아오기
    var index: Int?
    
    // titmer
    var remainingSeconds: Int?
    var timer = Timer()
    
    // 고민에 대한 윌스너 매치 목록 response model
    var concernMatch: ConcernMatch?
    var concernMatchData: ConcernMatchData?
    var concernMatchRows: [ConcernMatchRows]?
    
    // MARK: - IBOutlet
    @IBOutlet weak var timerImageView: UIImageView!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // GET 통신
        getRealtimeWillsonerList()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // collectionview delgate, datasource
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // timer
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(timeLimit), userInfo: nil, repeats: true)
    }
    
    // MARK: - Methods
    func getRealtimeWillsonerList() {
        guard let index = index else {
            print("index nil 값")
            return
        }
        AskerConcernServices.shared.getRealtimeWillsonerList(concernIndex: index) { concernMatch in
            self.concernMatch = concernMatch
            self.concernMatchData = self.concernMatch?.data
            self.concernMatchRows = self.concernMatchData?.matches
            
            print("====================")
            print("고민에 대한 윌스너 매치 목록 통신 성공")
            self.collectionView.reloadData()
        }
    }
    
    // timer
    @objc func timeLimit() {
        let timerFormatter = DateFormatter()
        
        if remainingSeconds! > -300 {
            remainingSeconds! -= 1
            timeLabel.text = "\((300 + remainingSeconds!) / 60):\((300 + remainingSeconds!) % 60)"
            timerFormatter.dateFormat = "mm:ss"
            if let formattime = timerFormatter.date(from:timeLabel.text ?? "") {
                timeLabel.text = timerFormatter.string(from: formattime)
            }
        } else {
            timeLimitStop()
        }
    }
    
    func timeLimitStop() {
        timer.invalidate()
        
        self.navigationController?.popViewController(animated: true)
    }
}

extension AskerRequestWillsonerListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let vc: AskerDetailRequestViewController = UIStoryboard(name: "AskerRequest", bundle: nil).instantiateViewController(withIdentifier: "AskerDetailRequestViewController") as? AskerDetailRequestViewController else {
            print("AskerDetailRequestViewController 할당 오류")
            return
        }
        guard let matchIndex = concernMatchData?.matches[indexPath.item].idx else {
            print("concernMatchData?.rows[indexPath.item].idx 할당 오류")
            return
        }
        vc.matchIndex = matchIndex
        self.navigationController?.show(vc, sender: nil)
    }
}

extension AskerRequestWillsonerListViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = concernMatchRows?.count {
            return count
        } else {
            print("numberOfItemsInSection: concernMatchRows?.count 할당 오류")
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header: WillsonerListHeaderCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentitier, for: indexPath) as? WillsonerListHeaderCollectionReusableView else {
                print("header view 할당 오류")
                return UICollectionReusableView()
            }
            
            return header
            
        case UICollectionView.elementKindSectionFooter:
            guard let footer: WillsonerListFooterCollectionReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: footerIdentifier, for: indexPath) as? WillsonerListFooterCollectionReusableView else {
                print("footer view 할당 오류")
                return UICollectionReusableView()
            }
            
            return footer
            
        default: return UICollectionReusableView()
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

extension AskerRequestWillsonerListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 96)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIScreen.main.bounds.width, height: 240)
    }
}
