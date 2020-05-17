//
//  RequestConcernCollectionViewCell.swift
//  Willson
//
//  Created by JHKim on 2020/01/20.
//

import UIKit

class RequestConcernCollectionViewCell: UICollectionViewCell {

    @IBOutlet var bgView: CustomView!
    
    @IBOutlet var categoryView: CustomView!
    @IBOutlet var categoryLabel: UILabel!
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var contentLabel: UILabel!
    @IBOutlet var hashTagLabel: UILabel!
    
    @IBOutlet var timeStackView: UIStackView!
    
    @IBOutlet var timeImageView: UIImageView!
    @IBOutlet var timeAnnounceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
