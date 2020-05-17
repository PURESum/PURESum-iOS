//
//  ChatAnnouncementTableViewCell.swift
//  Willson
//
//  Created by JHKim on 2019/11/17.
//

import UIKit

class ChatAnnouncementTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
