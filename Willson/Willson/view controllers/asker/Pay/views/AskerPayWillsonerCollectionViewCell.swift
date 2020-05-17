//
//  AskerPayWillsonerCollectionViewCell.swift
//  Willson
//
//  Created by JHKim on 2020/04/02.
//

import UIKit

class AskerPayWillsonerCollectionViewCell: UICollectionViewCell {

    @IBOutlet var bgView: CustomView!
    
    @IBOutlet var willsonerImageView: CustomImageView!
    @IBOutlet var nicknameLabel: UILabel!
    @IBOutlet var ageAndGenderLabel: UILabel!
    @IBOutlet var rateLabel: UILabel!
    
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var introduceLabel: UILabel!
    @IBOutlet var keywordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
