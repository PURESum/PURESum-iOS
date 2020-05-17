//
//  AskerHomeRecommandWillsonerCollectionViewCell.swift
//  Willson
//
//  Created by JHKim on 2020/03/31.
//

import UIKit

class AskerHomeRecommandWillsonerCollectionViewCell: UICollectionViewCell {

    @IBOutlet var willsonerImageView: CustomImageView!
    @IBOutlet var willsonerNicknameLabel: UILabel!
    @IBOutlet var willsonerAgeAndGenderLabel: UILabel!
    
    @IBOutlet var categoryLabel: CustomLabel!
    @IBOutlet var hashtagLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    @IBOutlet weak var starStackView: UIStackView!
    @IBOutlet var star1ImageView: UIImageView!
    @IBOutlet var star2ImageView: UIImageView!
    @IBOutlet var star3ImageView: UIImageView!
    @IBOutlet var star4ImageView: UIImageView!
    @IBOutlet var star5ImageView: UIImageView!
    
    @IBOutlet var rateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
