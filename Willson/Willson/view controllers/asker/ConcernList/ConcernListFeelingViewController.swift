//
//  ConcernListFeelingViewController.swift
//  Willson
//
//  Created by JHKim on 06/10/2019.
//

import UIKit
import Toast_Swift

class ConcernListFeelingViewController: UIViewController {

    // MARK: - properties
    let feelingCellIdentifier: String = "ConcernListDetailCategoryTableViewCell"
//    let feelingArray: [String] = ["신나요", "행복해요" , "자신감 넘쳐요", "자랑스러워요", "당황스러워요", "지쳐요", "슬퍼요", "두려워요", "무기력해요"]
    
    // 감정 인덱스 배열
    var selectedItems: [IndexPath]?
    
    // 고민신청 - 감정 network response
    var feeling: BasicModel?
    var feelingData: [IdxData]?
    
    // 로딩중 인디케이터
    lazy var activityIndicator: UIActivityIndicatorView = {
            // Create an indicator.
            let activityIndicator = UIActivityIndicatorView()
            activityIndicator.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
            activityIndicator.center = self.view.center
            activityIndicator.color = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            // Also show the indicator even when the animation is stopped.
            activityIndicator.hidesWhenStopped = true
            activityIndicator.style = UIActivityIndicatorView.Style.white
            // Start animation.
            activityIndicator.stopAnimating()
            return activityIndicator
        }()
    
    // MARK: - IBOutlet
    @IBOutlet weak var feelingTableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        guard let items = selectedItems else {
            print("selecteItems 할당 오류")
            return
        }
        var indexes: [Int] = []
        for item in items {
            indexes.append(item.row)
        }
        
        guard let feelingData = feelingData else {
            print("felling Data 할당 오류")
            return
        }
        
        var feelingIndex: [Int] = []
        for i in indexes {
            feelingIndex.append(feelingData[i].idx)
        }
        
        // UserDefaults 저장 - feelingIndex
        UserDefaults.standard.set(feelingIndex, forKey: "feelingIndex")
        
        guard let feeling = UserDefaults.standard.value(forKey: "feelingIndex") else {
            print("UserDefaults - feelingIndex 할당 오류")
            return
        }
        print("feeling Index: \(feeling)")
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 로딩중
        self.view.addSubview(self.activityIndicator)
        
        // 고민신청 - 감정 통신
        getFeeling()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // feel tableview delegate, datasource
        feelingTableView.delegate = self
        feelingTableView.dataSource = self
        
        feelingTableView.rowHeight = 45
        feelingTableView.separatorStyle = .none
        
        feelingTableView.allowsMultipleSelection = true
        
        // 처음에 버튼 비활성화
        nextButton.isEnabled = false
    }
    
    // MARK: - Methods
    func getFeeling() {
        AskerRequestServices.shared.getFeeling { feeling in
            self.feeling = feeling
            self.feelingData = self.feeling?.data
            print("================")
            print("고민신청 - 감정 통신 성공")
            
            self.feelingTableView.reloadData()
            self.feelingTableView.performBatchUpdates(nil, completion: {
                (result) in
                // ready
                // 인디케이터 중지
                self.activityIndicator.stopAnimating()
            })
        }
    }

}

extension ConcernListFeelingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedItems = tableView.indexPathsForSelectedRows {
            print("selectedItems: \(selectedItems)")
            
            // 선택된 감정 저장
            self.selectedItems = selectedItems
            
            // 3개 이상 선택하면 다음 버튼 활성화
            if selectedItems.count < 3 { nextButton.isEnabled = false }
            else { nextButton.isEnabled = true }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let selectedItems = tableView.indexPathsForSelectedRows {
            print("deSelectedItems: \(selectedItems)")
            
            // 선택된 감정 저장
            self.selectedItems = selectedItems
            
            // 3개 이상 선택하면 다음 버튼 활성화
            if selectedItems.count < 3 { nextButton.isEnabled = false }
            else { nextButton.isEnabled = true }
        }
    }
}

extension ConcernListFeelingViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = feelingData?.count else {
            print("feeling data count 오류")
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ConcernListDetailCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: feelingCellIdentifier, for: indexPath) as? ConcernListDetailCategoryTableViewCell else { return UITableViewCell() }
        
        guard let text = feelingData?[indexPath.row].name else {
            print("feeling data [indexPath.row] 할당 오류")
            return UITableViewCell()
        }
        cell.label.text = text
        cell.dotImageView.isHidden = true
        
        cell.selectionStyle = .none
        return cell
    }
    
    
}
