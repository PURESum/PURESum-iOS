//
//  HelperAuthorizationTableViewCell.swift
//  Willson
//
//  Created by JHKim on 13/10/2019.
//

import UIKit

class HelperAuthorizationTableViewCell: UITableViewCell {

    @IBOutlet var methodLabel: UILabel!
    @IBOutlet var button: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            button.setImage(UIImage(named: "icCheckCircleNavy"), for: .normal)
        } else {
            button.setImage(UIImage(named: "icCheckCircleGray"), for: .normal)
        }
    }
    
}
