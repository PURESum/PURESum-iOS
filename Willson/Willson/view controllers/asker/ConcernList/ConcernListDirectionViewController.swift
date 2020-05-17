//
//  ConcernListDirectionViewController.swift
//  Willson
//
//  Created by JHKim on 06/10/2019.
//

import UIKit

class ConcernListDirectionViewController: UIViewController {

    // MARK: - propeties
    let cellIdentifier: String = "ConcernListDirectionTableViewCell"
    
    // 선택된 대화방향
    var selectedRows: [IndexPath]?
    
//    let directionArray: [String] = ["공감을 얻고 싶어요", "문제를 해결하고 싶어요", "비슷한 경험을 듣고 싶어요"]
    // 대화 방향 통신 response model
    var direction: BasicModel?
    var directionData: [IdxData]?
    
    // MARK: - IBOutlet
    @IBOutlet weak var directionTableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        guard let row: Int = selectedRows?[0].row else {
            print("selected Rows[0].row 할당 오류")
            return
        }
        
        guard let directionIndex = directionData?[row].idx else {
            print("direction Index 할당 오류")
            return
        }
        
        // UserDefaults - directionIndex 저장
        UserDefaults.standard.set(directionIndex, forKey: "directionIndex")
        guard let direction = UserDefaults.standard.value(forKey: "directionIndex") else {
            print("UserDefaults - directionIndex 할당 에러")
            return
        }
        print("direction Index: \(direction)")
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableview delegate, datasource
        directionTableView.delegate = self
        directionTableView.dataSource = self
        
        directionTableView.rowHeight = 73
        directionTableView.separatorStyle = .none
        
        // 처음에 다음버튼 비활성화
        nextButton.isEnabled = false
        
        // 대화방향 통신
        getDirection()
    }
    
    // MARK: - Methods
    func getDirection() {
        AskerRequestServices.shared.getDirection { direction in
            self.direction = direction
            self.directionData = self.direction?.data
            print("=============")
            print("고민신청 - 대화 방향 통신 성공")
            
            self.directionTableView.reloadData()
        }
    }

}

extension ConcernListDirectionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedItems = tableView.indexPathsForSelectedRows {
            print("selectedItems: \(selectedItems)")
            // 1개 이상 선택하면 다음 버튼 활성화
            if selectedItems.count < 1 { nextButton.isEnabled = false }
            else {
                self.selectedRows = selectedItems
                nextButton.isEnabled = true
            }
        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let selectedItems = tableView.indexPathsForSelectedRows {
            print("deSelectedItems: \(selectedItems)")
            // 1개 이상 선택하면 다음 버튼 활성화
            if selectedItems.count < 1 { nextButton.isEnabled = false }
            else {
                self.selectedRows = selectedItems
                nextButton.isEnabled = true
            }
        }
    }
}

extension ConcernListDirectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = directionData?.count else {
            print("directiondata - count 할당 오류")
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ConcernListDirectionTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConcernListDirectionTableViewCell else { return UITableViewCell() }
        
        guard let text = directionData?[indexPath.row].name else {
            print("directiondata[indexPath.row] 할당 오류")
            return UITableViewCell()
        }
        cell.label.text = text
        
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return cell
    }
    
    
}
