//
//  AskerRuquestReviewCollectionViewCell.swift
//  Willson
//
//  Created by JHKim on 13/10/2019.
//

import UIKit

class AskerRequestReviewCollectionViewCell: UICollectionViewCell {

    // MARK: - IBOutlet
    @IBOutlet var bgView: CustomView!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var dataLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    
    @IBOutlet var rateImageView: UIImageView!
    @IBOutlet var rateLabel: UILabel!
    
    // MARK: - Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
