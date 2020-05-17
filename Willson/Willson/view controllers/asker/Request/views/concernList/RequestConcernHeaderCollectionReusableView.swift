//
//  RequestConcernHeaderCollectionReusableView.swift
//  Willson
//
//  Created by JHKim on 2020/01/21.
//

import UIKit

class RequestConcernHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet var titleLabel: UILabel!
    
    @IBOutlet var countView: CustomView!
    @IBOutlet var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
}
