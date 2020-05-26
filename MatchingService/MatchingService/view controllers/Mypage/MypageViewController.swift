//
//  MypageViewController.swift
//  MatchingService
//
//  Created by JHKim on 2020/05/26.
//  Copyright © 2020 zhi. All rights reserved.
//

import UIKit

class MypageViewController: UIViewController {

    // MARK: - properties
    let cellIdentifier: String = "mypageCell"
    
    // MARK: - IBOutlet
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
    }
    
    // MARK: - Methods

}

// MARK: - UITableViewDelegate
extension MypageViewController: UITableViewDelegate {
    
}

// MARK: - UITableViewDataSource
extension MypageViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: MypageTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? MypageTableViewCell else {
            return UITableViewCell()
        }
        
        switch indexPath.row {
        case 0:
            cell.titleLabel.text = "--"
        case 1:
            cell.titleLabel.text = "--"
        case 2:
            cell.titleLabel.text = "로그아웃"
        default: break
        }
        
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return cell
    }
}
