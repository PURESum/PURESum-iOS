//
//  HelperApplicationAdditionalAuthViewController.swift
//  Willson
//
//  Created by JHKim on 2019/11/19.
//

import UIKit

class HelperApplicationAdditionalAuthViewController: UIViewController {

    // MARK: - properties
    let cellIdentifier: String = "HelperAuthorizationTableViewCell"
    let methodArray: [String] = ["경험관련 링크 인증", "미디어 인증 (사진, 동영상 등)"]
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // table view delegate, datasource
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Methods
    
}

extension HelperApplicationAdditionalAuthViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "HelperApplication", bundle: nil)
        switch indexPath.row {
        case 0:
            let vc = storyboard.instantiateViewController(withIdentifier: "HelperApplicationExperienceLinkViewController")
            self.navigationController?.show(vc, sender: nil)
        case 1:
            let vc = storyboard.instantiateViewController(withIdentifier: "HelperApplicationPhotoVideoAuthViewController")
            self.navigationController?.show(vc, sender: nil)
        default: return
        }
    }
}

extension HelperApplicationAdditionalAuthViewController: UITableViewDataSource {
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
