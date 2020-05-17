//
//  TutorialConcernViewController.swift
//  Willson
//
//  Created by JHKim on 2020/03/24.
//

import UIKit

class TutorialConcernViewController: UIViewController {

    // MARK: - properties
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var detailLabel: CustomLabel!
    
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
        현재 하고 있는 답답한 고민에 대해 입력해주세요.
        그리고 매칭을 원하는 윌스너분의 특정 경험이 있다면
        꼭 입력해 주세요
        """
        detailLabel.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
        detailLabel.font = UIFont(name: "AppleSDGothicNeo-Light", size: 12)
        detailLabel.numberOfLines = 3
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
