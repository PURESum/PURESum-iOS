//
//  OtherChatTableViewCell.swift
//  Willson
//
//  Created by JHKim on 2020/02/17.
//

import UIKit

class OtherChatTableViewCell: UITableViewCell {

    @IBOutlet var chatView: UIView!
    @IBOutlet var messageLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        roundCorners(cornerRadius: 17.5)
    }

    func roundCorners(cornerRadius: Double) {
        /*
         layerMaxXMaxYCorner – lower right corner
         layerMaxXMinYCorner – top right corner
         layerMinXMaxYCorner – lower left corner
         layerMinXMinYCorner – top left corner
         */
        
        chatView.layer.cornerRadius = CGFloat(cornerRadius)
        chatView.clipsToBounds = true
        chatView.layer.maskedCorners = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner]
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
