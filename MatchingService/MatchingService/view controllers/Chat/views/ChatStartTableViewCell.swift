//
//  ChatStartTableViewCell.swift
//  Willson
//
//  Created by JHKim on 2020/02/24.
//

import UIKit

class ChatStartTableViewCell: UITableViewCell {

    @IBOutlet var lineView: UIView!
    @IBOutlet var announceLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
