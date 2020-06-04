
//
//  MatchCollectionViewCell.swift
//  MatchingService
//
//  Created by JHKim on 2020/05/06.
//  Copyright © 2020 zhi. All rights reserved.
//

import UIKit

class MatchCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var bgView: CustomView!
    
    @IBOutlet var indexLabel: UILabel!
    @IBOutlet var categoryLabel: UILabel!
    @IBOutlet var textView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
