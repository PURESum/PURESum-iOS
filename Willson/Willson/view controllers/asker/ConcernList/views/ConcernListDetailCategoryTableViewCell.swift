//
//  ConcernListDetailCategoryTableViewCell.swift
//  Willson
//
//  Created by JHKim on 06/10/2019.
//

import UIKit

class ConcernListDetailCategoryTableViewCell: UITableViewCell {

    @IBOutlet var label: UILabel!
    @IBOutlet var dotImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            label.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
            label.font = UIFont(name: "AppleSDGothicNeo-SemiBold", size: 22)
            dotImageView.isHidden = false
        } else {
            label.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            label.font = UIFont(name: "AppleSDGothicNeo-Regular", size: 22)
            dotImageView.isHidden = true
        }
    }
}
