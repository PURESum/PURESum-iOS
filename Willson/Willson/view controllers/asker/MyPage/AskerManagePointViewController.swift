//
//  AskerManagePointViewController
//  Willson
//
//  Created by JHKim on 2019/12/31.
//

import UIKit

class AskerManagePointViewController: UIViewController {

    // MARK: - properties
    let pointCellIdentifier: String = "AskerPointTableViewCell"
    let footerCellIdentifier: String = "MyPageFooterTableViewCell"
    let purchaseCellIdentifier: String = "PurchaseListTableViewCell"
    
    let pointTitleArray: [String] = ["고민나누기 30분", "고민나누기 60분", "고민나누기 120분"]
    let priceArray: [String] = ["5,900원", "7,200원", "9,900원"]
    
    let purchasePriceArray: [String] = ["+ 9,900 원", "+ 5,900 원", "- 4,200원", "+ 5,900원"]
    let purchaseContentArray: [String] = ["고민상담권 120분", "고민상담권 30분", "상담권 환급", "고민상담권 30분"]
    let purchaseDateArray: [String] = ["19.08.18", "19.02.07", "19.01.27", "18.12.19"]
    
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yy.mm.dd"
        return formatter
    }()
    
    // MARK: - IBOutlet
    // 보유 상담권 갯수
    @IBOutlet weak var min30CountLabel: UILabel!
    @IBOutlet weak var min60CountLabel: UILabel!
    @IBOutlet weak var min120CountLabel: UILabel!
    
    // 환급하기 버튼 뷰
    @IBOutlet weak var refundButtonView: CustomView!
    
    // 포인트샵 / 구매내역
    @IBOutlet weak var pointshopButtonView: UIView!
    @IBOutlet weak var pointshopLabel: UILabel!
    @IBOutlet weak var pointshopImageView: UIImageView!
    
    @IBOutlet weak var purchaseButtonView: UIView!
    @IBOutlet weak var purchaseLabel: UILabel!
    @IBOutlet weak var purchaseImageVIew: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableview delegate, datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.rowHeight = 55
        tableView.separatorStyle = .none
        
        // navibar title
        self.title = "상담권"
        
        // 초기엔 포인트샵 선택
        pointshopButtonView.tag = 1
        pointshopLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        pointshopImageView.image = UIImage(named: "icDotBlack")
        purchaseButtonView.tag = 0
        purchaseLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 16)
        purchaseImageVIew.image = UIImage()
        
        // tap gesture
        let pointshopGesture = UITapGestureRecognizer(target: self, action: #selector(tappedPointShopButonView(_:)))
        pointshopButtonView.addGestureRecognizer(pointshopGesture)
        let purchaseGesture = UITapGestureRecognizer(target: self, action: #selector(tappedPurchaseButtonView(_:)))
        purchaseButtonView.addGestureRecognizer(purchaseGesture)
    }
    
    // MARK: - Methods
    @objc func tappedPointShopButonView(_ gesture: UITapGestureRecognizer) {
        pointshopButtonView.tag = 1
        pointshopLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        pointshopImageView.image = UIImage(named: "icDotBlack")
        purchaseButtonView.tag = 0
        purchaseLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 16)
        purchaseImageVIew.image = UIImage()
        tableView.reloadData()
    }
    
    @objc func tappedPurchaseButtonView(_ gesture: UITapGestureRecognizer) {
        purchaseButtonView.tag = 1
        purchaseLabel.font = UIFont(name: "AppleSDGothicNeo-Bold", size: 16)
        purchaseImageVIew.image = UIImage(named: "icDotBlack")
        pointshopButtonView.tag = 0
        pointshopLabel.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 16)
        pointshopImageView.image = UIImage()
        tableView.reloadData()
    }

}

extension AskerManagePointViewController: UITableViewDelegate {
    
}

extension AskerManagePointViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if pointshopButtonView.tag == 1 {
            return pointTitleArray.count
        } else if purchaseButtonView.tag == 1 {
            return purchasePriceArray.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if pointshopButtonView.tag == 1 {
            let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
            guard let footerCell: MyPageFooterTableViewCell = tableView.dequeueReusableCell(withIdentifier: footerCellIdentifier) as? MyPageFooterTableViewCell else {
                print("viewForFooterInSection: footer cell 할당 오류")
                return UIView()
            }
            footerCell.frame = CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44)
            footerView.addSubview(footerCell)
            return footerView
        } else {
            return UIView()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if pointshopButtonView.tag == 1 {
            return 55
        } else if purchaseButtonView.tag == 1 {
            return 72
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if pointshopButtonView.tag == 1 {
            guard let cell: AskerPointTableViewCell = tableView.dequeueReusableCell(withIdentifier: pointCellIdentifier, for: indexPath) as? AskerPointTableViewCell else { return UITableViewCell() }
            
            cell.titleLabel.text = pointTitleArray[indexPath.row]
            cell.priceLabel.text = priceArray[indexPath.row]
            
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cell
        } else if purchaseButtonView.tag == 1 {
            guard let cell: PurchaseListTableViewCell = tableView.dequeueReusableCell(withIdentifier: purchaseCellIdentifier, for: indexPath) as? PurchaseListTableViewCell else { return UITableViewCell() }
            
            cell.priceLabel.text = purchasePriceArray[indexPath.row]
            cell.contentLabel.text = purchaseContentArray[indexPath.row]
            cell.dateLabel.text = purchaseDateArray[indexPath.row]
            
            cell.selectionStyle = .none
            cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
            return cell
        } else {
            return UITableViewCell()
        }
    }
}
