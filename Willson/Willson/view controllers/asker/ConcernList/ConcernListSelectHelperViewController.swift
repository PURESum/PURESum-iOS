//
//  ConcernListSelectHelperViewController.swift
//  Willson
//
//  Created by JHKim on 06/10/2019.
//

import UIKit

class ConcernListSelectHelperViewController: UIViewController {

    // MARK: - properties
    let characterCellIdentifier: String = "ConcernListDetailCategoryTableViewCell"
//    let characterArray: [String] = ["신중한", "호의적인", "열정적인", "감성적인"]
    
//    var selectedHelperPersonalityArray: [String] = []
    
    // 고민신청 완료 시 - will_gender, personality
    var willGender: String?
    var selectedRows: [IndexPath]?
    
    // 고민신청 - 헬퍼 성격 response model
    var willsonerType: BasicModel?
    var willsonerTypeData: [IdxData]?
    
    // MARK: - IBOutlet
    @IBOutlet weak var characterTableView: UITableView!
    
    @IBOutlet weak var femaleButton: UIButton!
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var bothButton: UIButton!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        guard let rows = selectedRows else {
            print("selectedRows 할당 오류")
            return
        }
        var indexes: [Int] = []
        for row in rows {
            indexes.append(row.row)
        }
        
        guard let personalityData = willsonerTypeData else {
            print("personality Data 할당 오류")
            return
        }
        
        var personalityIndex: [Int] = []
        for i in indexes {
            personalityIndex.append(personalityData[i].idx)
        }
        
        // UserDefaults 저장 - personalityIndex, willGender
        UserDefaults.standard.set(personalityIndex, forKey: "personalityIndex")
        UserDefaults.standard.set(willGender, forKey: "willGender")
        
        guard let personality = UserDefaults.standard.value(forKey: "personalityIndex") else {
            print("UserDefaults - personalityIndex 할당 오류")
            return
        }
        guard let gender = UserDefaults.standard.value(forKey: "willGender") else {
            print("UserDefaults - willGender 할당 오류")
            return
        }
        print("personality Index: \(personality)")
        print("will Gender: \(gender)")
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // character table view delegate, datasource
        characterTableView.delegate = self
        characterTableView.dataSource = self
        
        characterTableView.rowHeight = 45
        characterTableView.separatorStyle = .none
        
        characterTableView.allowsMultipleSelection = true
        // 처음에 버튼 비활성화
        nextButton.isEnabled = false
        
        // button add target
        femaleButton.addTarget(self, action: #selector(myButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        maleButton.addTarget(self, action: #selector(myButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        bothButton.addTarget(self, action: #selector(myButtonTapped(_:)), for: UIControl.Event.touchUpInside)
        
        // 헬퍼 성격 통신
        getWillsonerType()
    }

    // MARK: - Methods
    func checkCanActiveButton() {
        guard let count = selectedRows?.count else {
            print("selectedRows.count 할당 오류")
            return
        }
        if ((maleButton.tag + femaleButton.tag + bothButton.tag) == 1) && (count >= 3) {
                nextButton.isEnabled = true
        } else { nextButton.isEnabled = false }
    }
    
    @objc func myButtonTapped(_ button: UIButton){
        if button == femaleButton {
            if button.tag == 1 {
                button.tag = 0
                button.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), for: .normal)
                button.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            } else {
                if maleButton.tag == 1 {
                    maleButton.tag = 0
                    maleButton.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), for: .normal)
                    maleButton.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
                } else if bothButton.tag == 1 {
                    bothButton.tag = 0
                    bothButton.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), for: .normal)
                    bothButton.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
                }
                button.tag = 1
                button.backgroundColor = .clear
                button.setTitleColor(#colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1), for: .normal)
                button.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
                willGender = "F"
            }
        } else if button == maleButton {
            if button.tag == 1 {
                button.tag = 0
                button.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), for: .normal)
                button.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            } else {
                if femaleButton.tag == 1 {
                    femaleButton.tag = 0
                    femaleButton.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), for: .normal)
                    femaleButton.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
                } else if bothButton.tag == 1 {
                    bothButton.tag = 0
                    bothButton.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), for: .normal)
                    bothButton.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
                }
                button.tag = 1
                button.backgroundColor = .clear
                button.setTitleColor(#colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1), for: .normal)
                button.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
                willGender = "M"
            }
        } else if button == bothButton {
            if button.tag == 1 {
                button.tag = 0
                button.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), for: .normal)
                button.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            } else {
                if femaleButton.tag == 1 {
                    femaleButton.tag = 0
                    femaleButton.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), for: .normal)
                    femaleButton.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
                } else if maleButton.tag == 1 {
                    maleButton.tag = 0
                    maleButton.setTitleColor(#colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1), for: .normal)
                    maleButton.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
                }
                button.tag = 1
                button.backgroundColor = .clear
                button.setTitleColor(#colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1), for: .normal)
                button.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
                willGender = "All"
            }
        }
        checkCanActiveButton()
    }
    
    func getWillsonerType() {
        AskerRequestServices.shared.getWillsonerType { willsonerType in
            self.willsonerType = willsonerType
            self.willsonerTypeData = self.willsonerType?.data
            print("================")
            print("헬퍼 성격 통신 성공")
            
            self.characterTableView.reloadData()
        }
    }
}

extension ConcernListSelectHelperViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            print("selectedRows: \(selectedRows)")
            
            // 선택된 성격 저장
            self.selectedRows = selectedRows
            
            // 3개 이상 선택하면 다음 버튼 활성화
            checkCanActiveButton()
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            print("deSelectedRows: \(selectedRows)")
            
            // 선택된 성격 저장
            self.selectedRows = selectedRows
            
            // 3개 이상 선택하면 다음 버튼 활성화
            checkCanActiveButton()
        }
    }
}

extension ConcernListSelectHelperViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = willsonerTypeData?.count else {
            print("willsoner type data count 오류")
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ConcernListDetailCategoryTableViewCell = tableView.dequeueReusableCell(withIdentifier: characterCellIdentifier, for: indexPath) as? ConcernListDetailCategoryTableViewCell else { return UITableViewCell() }
        guard let text = willsonerTypeData?[indexPath.row].name else {
            print("willsoner type data [indexPath.row] 할당 오류")
            return UITableViewCell()
        }
        cell.label.text = text
        cell.selectionStyle = .none
        return cell
    }
}
