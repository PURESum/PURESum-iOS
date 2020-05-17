//
//  AskerChatHistoryViewController.swift
//  Willson
//
//  Created by JHKim on 2020/02/27.
//

import UIKit
import Kingfisher

class AskerChatHistoryViewController: UIViewController {

    // MARK: - properties
    let cellIdentifier: String = "chatHistoryTableViewCell"
    
    // history response model
    var mypageHistory: AskerMypageHistory?
    var mypageHistoryData: [AskerMypageHistoryData]?
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // GET 통신
        getHistory()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // navibar title
        self.title = "상담내역"
        
        // tableView delegate, dataSource
        tableView.delegate = self
        tableView.dataSource = self
        
//        tableView.separatorStyle = .none
        tableView.rowHeight = 140
        tableView.tableFooterView = UIView()
    }

    // MARK: - Methods
    func getHistory() {
        AskerMypageServices.shared.getAskerMypageHistory() { mypageHistory in
            self.mypageHistory = mypageHistory
            self.mypageHistoryData = self.mypageHistory?.data
            print("===============")
            print("마이페이지: 상담내역(질문자) 통신 성공 ! ")
            
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate
extension AskerChatHistoryViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension AskerChatHistoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = mypageHistoryData?.count else {
            print("numberOfRowsInSection: count 할당 오류")
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: chatHistoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? chatHistoryTableViewCell else {
            print("cellForRowAt: chatHistoryTableViewCell 할당 오류")
            return UITableViewCell()
        }
        
        // 이미지
        guard let urlString = mypageHistoryData?[indexPath.row].willsoner.image?.pic else {
            print("cellForRowAt: urlString 할당 오류")
            return UITableViewCell()
        }
        let url = URL(string: urlString)
        cell.profileImageView.kf.setImage(with: url)
        
        // 닉네임
        guard let nickname = mypageHistoryData?[indexPath.row].willsoner.asker.nickname else {
            print("cellForRowAt: nickname 할당 오류")
            return UITableViewCell()
        }
        cell.nicknameLabel.text = nickname
        
        // 카테고리
        guard let category = mypageHistoryData?[indexPath.row].category else {
            print("cellForRowAt: category 할당 오류")
            return UITableViewCell()
        }
        cell.categoryLabel.text = category
        
        // 날짜
        guard let date = mypageHistoryData?[indexPath.row].date else {
            print("cellForRowAt: date 할당 오류")
            return UITableViewCell()
        }
        cell.dateLabel.text = date
        
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return cell
    }
    
    
}
