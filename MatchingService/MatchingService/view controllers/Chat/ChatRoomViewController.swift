//
//  ChatRoomViewController.swift
//  MatchingService
//
//  Created by JHKim on 2020/05/24.
//  Copyright © 2020 zhi. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {

    // MARK: - properties
    
    // MARK: - IBOutlet
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableview delegate, dataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
    }

    // MARK: - Methods
}

extension ChatRoomViewController: UITableViewDelegate {
    
}

extension ChatRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
