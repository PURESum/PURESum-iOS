//
//  ConcernListConcernTableViewCell.swift
//  Willson
//
//  Created by JHKim on 2019/12/29.
//

import UIKit

class ConcernListConcernTableViewCell: UITableViewCell {

    // MARK: - properties
    weak var delegate: ConcernListWriteStoryViewController?
    
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
            bgView.layer.backgroundColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
            label.textColor = .white
        } else {
            bgView.layer.borderColor = #colorLiteral(red: 0.8901960784, green: 0.8901960784, blue: 0.8901960784, alpha: 1)
            bgView.layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            label.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        }
    }
    
}
