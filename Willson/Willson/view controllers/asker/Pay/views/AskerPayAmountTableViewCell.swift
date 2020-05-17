//
//  AskerPayAmountTableViewCell.swift
//  Willson
//
//  Created by JHKim on 31/10/2019.
//

import UIKit

class AskerPayAmountTableViewCell: UITableViewCell {

    @IBOutlet var amountImageView: UIImageView!
    @IBOutlet var amountLabel: UILabel!
    @IBOutlet var amountButton: CustomButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if selected {
            layer.backgroundColor = #colorLiteral(red: 0.9647058824, green: 0.9647058824, blue: 0.9647058824, alpha: 1)
        } else {
            layer.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        }
    }
}
