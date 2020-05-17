//
//  ConcernListDirectionTableViewCell.swift
//  Willson
//
//  Created by JHKim on 2019/12/29.
//

import UIKit

class ConcernListDirectionTableViewCell: UITableViewCell {

    // MARK: - properties
    
    // MARK: - IBOutlet
    @IBOutlet var bgView: CustomView!
    @IBOutlet var label: UILabel!
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            bgView.layer.borderColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
            label.textColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
        } else {
            bgView.layer.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            label.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        }
    }
    
}
