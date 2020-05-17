//
//  ChatAgreementTableViewCell.swift
//  Willson
//
//  Created by JHKim on 2020/02/23.
//

import UIKit

class ChatAgreementTableViewCell: UITableViewCell {

    // MARK: - properties
    // this will be our "call back" action
//    var btnTapAction : (()->())?
    
    // MARK: - IBOutlet
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var announceLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var lastLabel: UILabel!
    
    @IBOutlet var agreementView: UIView!
    @IBOutlet var checkImageView: UIImageView!
    @IBOutlet var agreementLabel: UILabel!
    @IBOutlet var agreementDetailLabel: UILabel!
    
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
