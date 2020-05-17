//
//  AskerHomeReviewCollectionViewCell.swift
//  Willson
//
//  Created by JHKim on 2020/03/31.
//

import UIKit

class AskerHomeReviewCollectionViewCell: UICollectionViewCell {

    @IBOutlet var bgView: CustomView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var starImageView: UIImageView!
    @IBOutlet var rateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
