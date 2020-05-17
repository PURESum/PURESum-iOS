//
//  ConcernListDetailCategoryViewController.swift
//  Willson
//
//  Created by JHKim on 2020/01/07.
//

import UIKit

class ConcernListDetailCategoryViewController: UIViewController {

    // MARK: - properties
    let cellIdentifier: String = "ConcernListDetailCategoryTableViewCell"
    
    //    let detailCategoryArray: [String] = ["짝사랑", "썸", "갈등", "이별", "재회", "결혼", "이혼", "기타"]
    
    // 서브 카테고리 인덱스
    var subCategoryIndex: Int?

    // subCategory - response model
    var subCategory: BasicModel?
    var subCategoryData: [IdxData]?
    
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
    @IBOutlet weak var detailCategoryTableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedNextButton(_ sender: Any) {
        // UserDefaults - subCategoryIndex
        UserDefaults.standard.set(subCategoryIndex, forKey: "subCategoryIndex")
        guard let index = UserDefaults.standard.value(forKey: "subCategoryIndex") else {
            print("userdefault - subCategoryIndex 할당 오류")
            return
        }
        print("서브 카테고리 인덱스: \(index)")
    }
    
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        // 로딩중
        self.view.addSubview(self.activityIndicator)
        // 로딩중 시작
        self.activityIndicator.startAnimating()
        
        // 세부 카테고리 networking
        getSubCategory()
    }
    
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
        AskerRequestServices.shared.postSubCategory(categoryIndex: categoryIndex) { subCategory in
            self.subCategory = subCategory
            self.subCategoryData = self.subCategory?.data
            print("===============")
            print("POST 세부 카테고리 통신 완료")
            
            self.detailCategoryTableView.reloadData()
            self.detailCategoryTableView.performBatchUpdates(nil, completion: {
                (result) in
                // ready
                // 인디케이터 중지
                self.activityIndicator.stopAnimating()
            })
        }
    }
}

extension ConcernListDetailCategoryViewController: UITableViewDelegate {
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

extension ConcernListDetailCategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = subCategoryData?.count else {
            print("sub category data count 할당 오류")
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ConcernListDetailCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConcernListDetailCategoryTableViewCell else { return UITableViewCell() }
        
        guard let name = subCategoryData?[indexPath.item].name else {
            print("subCategoryData - name 할당 오류")
            return UITableViewCell()
        }
        cell.label.text = name
        
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return cell
    }
}
