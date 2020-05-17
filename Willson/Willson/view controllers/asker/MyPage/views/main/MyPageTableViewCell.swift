//
//  MyPageTableViewCell.swift
//  Willson
//
//  Created by JHKim on 2019/12/31.
//

import UIKit

class MyPageTableViewCell: UITableViewCell {

    // MARK: - IBOutlet
    @IBOutlet var label: UILabel!

    @IBOutlet var disclosureImageView: UIImageView!
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
