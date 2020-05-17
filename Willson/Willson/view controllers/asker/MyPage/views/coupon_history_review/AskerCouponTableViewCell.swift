//
//  AskerCouponTableViewCell.swift
//  Willson
//
//  Created by JHKim on 2020/03/05.
//

import UIKit

class AskerCouponTableViewCell: UITableViewCell {

    @IBOutlet var categoryLabel: CustomLabel!
    @IBOutlet var titleLabel: UILabel!
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
