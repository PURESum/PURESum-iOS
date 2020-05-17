//
//  ChatListRoomTableViewCell.swift
//  Willson
//
//  Created by JHKim on 06/10/2019.
//

import UIKit

class ChatListRoomTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlet
    @IBOutlet var profileImageView: CustomImageView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var alertLabel: UILabel!
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // corners radius
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
