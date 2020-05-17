//
//  RequestWillsonerListCollectionViewCell.swift
//  Willson
//
//  Created by JHKim on 2020/01/30.
//

import UIKit

class RequestWillsonerListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imageView: CustomImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var ageAndGenderLabel: UILabel!
    
    @IBOutlet var starImageView: UIImageView!
    @IBOutlet var rateLabel: UILabel!
    
    @IBOutlet var bgView: CustomView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var hashTagLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
