//
//  AskerMypageNoticeViewController.swift
//  Willson
//
//  Created by JHKim on 2020/02/27.
//

import UIKit

class AskerMypageNoticeViewController: UIViewController {

    // MARK: - properties
    let cellIdentifier: String = "AskerMypageNoticeTableViewCell"
    
    // notice response model
    var mypageNotice: AskerMypageNotice?
    var mypageNoticeData: [AskerMypageNoticeData]?
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navibar title
        self.title = "공지사항"

        // tableView delegate, dataSource
        tableView.delegate = self
        tableView.dataSource = self
        
//        tableView.rowHeight = 68
        tableView.tableFooterView = UIView()
        
        // GET 통신
        getMypageNotices()
    }

    // MARK: - Methods
    func getMypageNotices() {
        AskerMypageServices.shared.getAskerMypageNotices() { mypageNotice in
            self.mypageNotice = mypageNotice
            self.mypageNoticeData = self.mypageNotice?.data
            print("===============")
            print("마이페이지 (질문자) 공지사항 통신 성공 !")
            
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate
extension AskerMypageNoticeViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension AskerMypageNoticeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = mypageNoticeData?.count else {
            print("numberOfRowsInSection: count 할당 오류")
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: AskerMypageNoticeTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AskerMypageNoticeTableViewCell else {
            print("cellForRowAt: AskerMypageNoticeTableViewCell 할당 오류")
            return UITableViewCell()
        }
        
        // 제목
        guard let title = mypageNoticeData?[indexPath.row].title else {
            print("cellForRowAt: title 할당 오류")
            return UITableViewCell()
        }
        cell.titleLabel.text = title
        
        // 내용
        
        // 날짜
        guard let date = mypageNoticeData?[indexPath.row].date else {
            print("cellForRowAt: date 할당 오류")
            return UITableViewCell()
        }
        cell.dateLabel.text = date
        
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return cell
    }
    
    
}
