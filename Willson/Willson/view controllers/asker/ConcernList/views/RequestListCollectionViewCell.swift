//
//  RequestListCollectionViewCell.swift
//  Willson
//
//  Created by JHKim on 09/10/2019.
//

import UIKit

class RequestListCollectionViewCell: UICollectionViewCell {

    @IBOutlet var profileImageView: UIImageView!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var sortingLabel: UILabel!
    @IBOutlet var detailCategoryLabel: UILabel!
    @IBOutlet var detailLabel: UILabel!
    @IBOutlet var hashtagLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
