//
//  TutorialChatViewController.swift
//  Willson
//
//  Created by JHKim on 2020/03/24.
//

import UIKit

class TutorialChatViewController: UIViewController {

    // MARK: - properties
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up
        setUp()
    }

    // MARK: - Methods
    func setUp() {
        detailLabel.text = """
        익명으로 해당 윌스너 분과 정해진 시간동안 마음껏
        고민을 나워보세요. 함께 집중하여 고민을 풀어가세요.
        """
        detailLabel.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        detailLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12)
        detailLabel.numberOfLines = 2
        guard let string = detailLabel.text else {
            print("detailLabel text 할당 오류")
            return
        }
        let attrString = NSMutableAttributedString(string: string)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        attrString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attrString.length))
        detailLabel.attributedText = attrString
    }
}
