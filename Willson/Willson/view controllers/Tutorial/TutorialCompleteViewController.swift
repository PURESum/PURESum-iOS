//
//  TutorialCompleteViewController.swift
//  Willson
//
//  Created by JHKim on 2020/03/24.
//

import UIKit

class TutorialCompleteViewController: UIViewController {

    // MARK: - properties
    
    // MARK: - IBOutlet
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var completeButton: CustomButton!
    
    // MARK: - IBAction
    @IBAction func tappedCompleteButton(_ sender: Any) {
        // 튜토리얼은 앱 실행 처음에만 보여주도록!
        UserDefaults.standard.set(true, forKey: "tutorialRead")
        
        let vc = UIStoryboard(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController")
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up
        setUp()
    }

    // MARK: - Methods
    func setUp() {
        detailLabel.text = """
        윌스너와 고민에 대해서 얘기하다보면 고민이
        금방 해결되실거에요 :) 다른 분의 리뷰도 확인해주세요
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
