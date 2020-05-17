//
//  AskerMypageReviewViewController.swift
//  Willson
//
//  Created by JHKim on 2020/02/27.
//

import UIKit

class AskerMypageReviewViewController: UIViewController {

    // MARK: - properties
    let cellIdentifier: String = "AskerMypageReviewTableViewCell"
    
    // review response model
    var mypageReview: AskerMypageReview?
    var mypageReviewData: AskerMypageReviewData?
    
    // MARK: - IBOutlet
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableView delegate, dateSource
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.rowHeight = 365
        
        // GET 통신
        getMypageReview()
    }

    // MARK: - Methods
    func getMypageReview() {
        AskerMypageServices.shared.getAskerMypageReviews() { mypageReview in
            self.mypageReview = mypageReview
            self.mypageReviewData = self.mypageReview?.data
            print("================")
            print("내가 쓴 리뷰 통신 성공")
            
            guard let count = self.mypageReviewData?.count else {
                print("getMypageReview: count 할당 오류")
                return
            }
            self.countLabel.text = "\(count)"
            self.loadViewIfNeeded()
            self.tableView.reloadData()
        }
    }
}

// MARK: - UITableViewDelegate
extension AskerMypageReviewViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

// MARK: - UITableViewDataSource
extension AskerMypageReviewViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = mypageReviewData?.count else {
            print("numberOfRowsInSection: count 할당 오류")
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: AskerMypageReviewTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AskerMypageReviewTableViewCell else {
            print("cellForRowAt: AskerMypageReviewTableViewCell 할당 오류")
            return UITableViewCell()
        }
        
        // 카테고리
        if let category = mypageReviewData?.rows[indexPath.row].category {
            cell.categoryLabel.text = category
        } else {
            print("cellForRowAt: category 할당 오류")
            cell.categoryLabel.text = ""
        }
        
        
        // 닉네임
        if let nickname = mypageReviewData?.rows[indexPath.row].willsoner {
            cell.nicknameLabel.text = nickname
        } else {
            print("cellForRowAt: willsoner nickname 할당 오류")
            cell.nicknameLabel.text = ""
        }
        
        // 별점
        if let rating = mypageReviewData?.rows[indexPath.row].rating {
            cell.rateLabel.text = "\(rating)"
        } else {
            print("cellForRowAt: rating 할당 오류")
            cell.rateLabel.text = ""
        }
        
        // 타입
        cell.typeLabel.numberOfLines = 0
        if let type = mypageReviewData?.rows[indexPath.row].image?.detail {
            cell.typeLabel.text = type
        } else {
            print("cellForRowAt: type 할당 오류")
            cell.typeLabel.text = ""
        }
        
        // 제목
        if let title = mypageReviewData?.rows[indexPath.row].title {
            cell.titleLabel.text = title
        } else {
            print("cellForRowAt: title 할당 오류")
            cell.titleLabel.text = ""
        }
        
        // 내용
        cell.contentLabel.numberOfLines = 0
        if let content = mypageReviewData?.rows[indexPath.row].content {
            cell.contentLabel.text = content
        } else {
            print("cellForRowAt: content 할당 오류")
            cell.contentLabel.text = ""
        }
        
        // 날짜
        if let date = mypageReviewData?.rows[indexPath.row].date {
            cell.dateLabel.text = date
        } else {
            print("cellForRowAt: date 할당 오류")
            cell.dateLabel.text = ""
        }
        
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return cell
    }
    
}
