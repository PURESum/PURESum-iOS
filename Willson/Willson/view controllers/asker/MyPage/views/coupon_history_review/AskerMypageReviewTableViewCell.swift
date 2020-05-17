//
//  AskerMypageReviewTableViewCell.swift
//  Willson
//
//  Created by JHKim on 2020/02/27.
//

import UIKit

class AskerMypageReviewTableViewCell: UITableViewCell {

    @IBOutlet var bgView: CustomView!
    
    @IBOutlet var categoryLabel: UILabel!
    
    @IBOutlet var moreButton: UIButton!
    
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var rateLabel: UILabel!
    @IBOutlet var typeLabel: UILabel!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
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
