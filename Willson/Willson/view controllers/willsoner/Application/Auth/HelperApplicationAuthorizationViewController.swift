//
//  HelperApplicationAuthorizationViewController.swift
//  Willson
//
//  Created by JHKim on 13/10/2019.
//

import UIKit
import Toast_Swift

class HelperApplicationAuthorizationViewController: UIViewController {

    // MARK: - properties
    let cellIdentifier: String = "HelperAuthorizationTableViewCell"
    let methodArray: [String] = ["신분증 인증", "휴대폰 인증", "이메일 인증"]
    
    var selectedRow: Int?
    
    // MARK: - IBOutlet
    @IBOutlet weak var authorizationTableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "HelperApplication", bundle: nil)
        switch selectedRow {
        case 0:
            /*
            let vc = storyboard.instantiateViewController(withIdentifier: "AuthenticationIDCardViewController")
            self.navigationController?.show(vc, sender: nil)
            */
            self.view.makeToast("현재 버전에서 지원하지 않는 기능입니다.",
            duration: 3.0,
            position: .bottom,
             style: ToastStyle())
        case 1:
            let vc = storyboard.instantiateViewController(withIdentifier: "HelperApplicationPhoneNumberViewController")
            self.navigationController?.show(vc, sender: nil)
        case 2:
            /*
            let vc = storyboard.instantiateViewController(withIdentifier: "HelperApplicationEmailViewController")
            self.navigationController?.show(vc, sender: nil)
            */
            self.view.makeToast("현재 버전에서 지원하지 않는 기능입니다.",
            duration: 3.0,
            position: .bottom,
             style: ToastStyle())
        /*case 3:
            let vc = storyboard.instantiateViewController(withIdentifier: "HelperApplicationExperienceLinkViewController")
            self.navigationController?.show(vc, sender: nil)*/
        default: break
        }
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableview delegate, datasource
        authorizationTableView.delegate = self
        authorizationTableView.dataSource = self
        
        authorizationTableView.rowHeight = 65
        authorizationTableView.tableFooterView = UIView()
        authorizationTableView.isScrollEnabled = false
        
        // 처음에 버튼 비활성화
        nextButton.isEnabled = false
    }

    // MARK: - Methods
    func checkAllInfoFilled() {
        if selectedRow != nil {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
}

extension HelperApplicationAuthorizationViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedRow = indexPath.row
        checkAllInfoFilled()
    }
}

extension HelperApplicationAuthorizationViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return methodArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: HelperAuthorizationTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HelperAuthorizationTableViewCell else { return UITableViewCell() }
        
        cell.methodLabel.text = methodArray[indexPath.row]
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        cell.selectionStyle = .none
        return cell
    }
    
    
}
