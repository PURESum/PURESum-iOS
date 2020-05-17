//
//  HelperApplicationDetailCategoryViewController.swift
//  Willson
//
//  Created by JHKim on 13/10/2019.
//

import UIKit

class HelperApplicationDetailCategoryViewController: UIViewController {

    // MARK: - properties
    let cellIdentifier: String = "ConcernListDetailCategoryTableViewCell"
//    let categoryArray: [String] = ["짝사랑", "썸", "갈등", "이별", "재회", "결혼", "이혼", "기타"]
    
    // 서브 카테고리 인덱스
    var subCategoryIndex: Int?
    
    // subCategory - response model
    var subCategory: BasicModel?
    var subCategoryData: [IdxData]?
    
    // MARK: - IBOutlet
    @IBOutlet weak var detailCategoryTableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        // UserDefaults - subCategoryIndex
        UserDefaults.standard.set(subCategoryIndex, forKey: "subCategoryIndex")
        guard let index = UserDefaults.standard.value(forKey: "subCategoryIndex") else {
            print("userdefault - subCategoryIndex 할당 오류")
            return
        }
        print("서브 카테고리 인덱스: \(index)")
        
        let vc = UIStoryboard(name: "HelperApplication", bundle: nil).instantiateViewController(withIdentifier: "HelperApplicationExperienceViewController")
        self.show(vc, sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // 세부 카테고리 networking
        getSubCategory()
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableview delegate, datasource
        detailCategoryTableView.delegate = self
        detailCategoryTableView.dataSource = self
        detailCategoryTableView.rowHeight = 40
        detailCategoryTableView.separatorStyle = .none
        
        // 처음에 버튼 비활성화
        nextButton.isEnabled = false
    }

    // MARK: - Methods
    func getSubCategory() {
        guard let categoryIndex: Int = UserDefaults.standard.value(forKey: "categoryIndex") as? Int else {
            print("============")
            print("UserDefaults - category index 할당 오류")
            return
        }
        print("categoryIndex: \(categoryIndex)")
        // post 통신
        WillsonerRegisterServices.shared.postSubCategory(categoryIndex: categoryIndex) { subCategory in
            self.subCategory = subCategory
            self.subCategoryData = self.subCategory?.data
            print("===============")
            print("POST 세부 카테고리 통신 완료")
            
            self.detailCategoryTableView.reloadData()
        }
    }
}

extension HelperApplicationDetailCategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedItems = tableView.indexPathsForSelectedRows {
            print("selectedItems: \(selectedItems)")
            // 1개 이상 선택하면 다음 버튼 활성화
            if selectedItems.count < 1 { nextButton.isEnabled = false }
            else {
                guard let index = subCategoryData?[indexPath.row].idx else {
                    print("sub category data - index 할당 오류")
                    return
                }
                subCategoryIndex = index
                nextButton.isEnabled = true }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let selectedItems = tableView.indexPathsForSelectedRows {
            print("deSelectedItems: \(selectedItems)")
            // 1개 이상 선택하면 다음 버튼 활성화
            if selectedItems.count < 1 { nextButton.isEnabled = false }
            else {
                guard let index = subCategoryData?[indexPath.row].idx else {
                    print("sub category data - index 할당 오류")
                    return
                }
                subCategoryIndex = index
                nextButton.isEnabled = true }
        }
    }
}

extension HelperApplicationDetailCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = subCategoryData?.count else {
            print("sub category data count 할당 오류")
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell: ConcernListDetailCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? ConcernListDetailCategoryTableViewCell else { return UITableViewCell() }
        
        guard let name = subCategoryData?[indexPath.item].name else {
            print("subCategoryData - name 할당 오류")
            return UITableViewCell()
        }
        cell.label.text = name
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.selectionStyle = .none
        return cell
    }
    
    
}
