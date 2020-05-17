//
//  HelperImageCollectionViewCell.swift
//  Willson
//
//  Created by JHKim on 13/10/2019.
//

import UIKit

class HelperImageCollectionViewCell: UICollectionViewCell {

    @IBOutlet var bgView: CustomView!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var checkButtonImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
