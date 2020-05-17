//
//  AskerHomeWillsonerStoryCollectionViewCell.swift
//  Willson
//
//  Created by JHKim on 2020/03/31.
//

import UIKit

class AskerHomeWillsonerStoryCollectionViewCell: UICollectionViewCell {

    @IBOutlet var bgView: CustomView!
    
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var countLabel: UILabel!
    
    @IBOutlet var heartButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
