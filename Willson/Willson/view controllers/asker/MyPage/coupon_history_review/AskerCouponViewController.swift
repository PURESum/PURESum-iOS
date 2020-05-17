//
//  AskerCouponViewController.swift
//  Willson
//
//  Created by JHKim on 2020/03/05.
//

import UIKit

class AskerCouponViewController: UIViewController {

    // MARK: - properties
    let cellIdentifier: String = "AskerCouponTableViewCell"
    
    // coupon response model
    var mypageCoupon: AskerMypageCoupon?
    var couponData: CouponData?
    
    // MARK: - IBOutlet
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // GET 통신
        getCoupon()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableview delegate, dataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 154
        tableView.tableFooterView = UIView()
    }

    // MARK: - Methods
    func getCoupon() {
        AskerMypageServices.shared.getAskerMypageCoupon() { mypageCoupon in
            self.mypageCoupon = mypageCoupon
            self.couponData = self.mypageCoupon?.data
            print("=============")
            print("마이페이지(질문자) 내 쿠폰 통신 성공 !")
            
            if let count = self.couponData?.coupons.count {
                self.countLabel.text = "\(count)"
                self.tableView.isHidden = false
                self.view.backgroundColor = .white
                self.tableView.reloadData()
            } else {
                self.countLabel.text = "0"
                self.tableView.isHidden = true
                self.view.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
                self.loadViewIfNeeded()
            }
        }
    }
}

extension AskerCouponViewController: UITableViewDelegate {
    
}

extension AskerCouponViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = couponData?.coupons.count else {
            print("numberOfRowsInSection: count 할당 오류")
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: AskerCouponTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? AskerCouponTableViewCell else {
            print("cellForRowAt: cell 할당 오류")
            return UITableViewCell()
        }
        
        // 카테고리
        guard let category = couponData?.coupons[indexPath.row].title else {
            print("cellForRowAt: category 할당 오류")
            return UITableViewCell()
        }
        cell.categoryLabel.text = category
        
        // 타이틀
        guard let title = couponData?.coupons[indexPath.row].name else {
            print("cellForRowAt: title 할당 오류")
            return UITableViewCell()
        }
        cell.titleLabel.text = title
        
        // 기간
        guard let fromDate = couponData?.coupons[indexPath.row].fromDate else {
            print("cellForRowAt: fromDate 할당 오류")
            return UITableViewCell()
        }
        guard let toDate = couponData?.coupons[indexPath.row].toDate else {
            print("cellForRowAt: toDate 할당 오류")
            return UITableViewCell()
        }
        cell.dateLabel.text = "\(fromDate) - \(toDate)"
        
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return cell
    }
    
    
}
