//
//  TutorialWillsonerViewController.swift
//  Willson
//
//  Created by JHKim on 2020/03/24.
//

import UIKit

class TutorialWillsonerViewController: UIViewController {

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
        해당 고민에 딱 알맞은 윌스너를 선정하여 보내드립니다.
        확인 후 원하시는 윌스너를 선정하고 상담을 진행해주세요.
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
