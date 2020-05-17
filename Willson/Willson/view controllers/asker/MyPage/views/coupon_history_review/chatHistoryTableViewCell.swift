//
//  chatHistoryTableViewCell.swift
//  Willson
//
//  Created by JHKim on 2020/02/27.
//

import UIKit

class chatHistoryTableViewCell: UITableViewCell {

    @IBOutlet var profileImageView: CustomImageView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    
    @IBOutlet var reviewButtonView: CustomView!
    @IBOutlet var applyButtonView: CustomView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
