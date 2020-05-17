
//
//  AuthenticationIDCardViewController.swift
//  Willson
//
//  Created by JHKim on 2019/11/10.
//

import UIKit

class AuthenticationIDCardViewController: UIViewController {
    
    // MARK: - properties
    var cameraImage: UIImage = UIImage()
    
    // 헬퍼 등록 완료 reponse model
    var registerComplete: RegisterComplete?
    var registerCompleteData: RegisterCompleteData?
    
    // MARK: - IBOutlet
    @IBOutlet weak var IDCardButton: UIButton!
    @IBOutlet weak var driverLicenceButton: UIButton!
    @IBOutlet weak var otherCardButton: UIButton!
    
    @IBOutlet weak var IDCardImageView: UIImageView!
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var completeButton: UIButton!
    // MARK: - IBAction
    @IBAction func tappedPlusButton(_ sender: Any) {
        guard let vc: AuthenticationAlertViewController = UIStoryboard(name: "HelperApplication", bundle: nil).instantiateViewController(withIdentifier: "AuthenticationAlertViewController") as? AuthenticationAlertViewController else { return }
        vc.preferredContentSize = CGSize(width: 316, height: 493)
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.setValue(vc, forKey: "contentViewController")
        
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        /*
        let vc = UIStoryboard(name: "HelperApplication", bundle: nil).instantiateViewController(withIdentifier: "HelperApplicationAdditionalAuthViewController")
        self.navigationController?.show(vc, sender: nil)
         */
        guard let categoryIndex = UserDefaults.standard.value(forKey: "categoryIndex") as? Int else {
            print("UserDefaults - categoryIndex 할당 오류")
            return
        }
        print("UserDefaults - categoryIndex: \(categoryIndex)")
        guard let subCategoryIndex = UserDefaults.standard.value(forKey: "subCategoryIndex") as? Int else {
            print("UserDefaults - subCategoryIndex 할당 오류")
            return
        }
        print("UserDefaults - subCategoryIndex \(subCategoryIndex)")
        guard let experience = UserDefaults.standard.value(forKey: "experience") as? String else {
            print("UserDefaults - experience 할당 오류")
            return
        }
        print("UserDefaults - experience: \(experience)")
        guard let keywordIndex = UserDefaults.standard.value(forKey: "keywordIndex") as? [Int] else {
            print("UserDefaults - keywordIndex 할당 오류")
            return
        }
        print("UserDefualts - keywordIndex: \(keywordIndex)")
        guard let introduction = UserDefaults.standard.value(forKey: "introduction") as? String else {
            print("UserDefaults - introduction 할당 오류")
            return
        }
        print("UserDefaults - introduction: \(introduction)")
        guard let imageIndex = UserDefaults.standard.value(forKey: "imageIndex") as? Int else {
            print("UserDefaults - imageIndex 할당 오류")
            return
        }
        print("UserDefaults - imageIndex: \(imageIndex)")
        UserDefaults.standard.set("idCard", forKey: "authentication")
        guard let authentication = UserDefaults.standard.value(forKey: "authentication") as? String else {
            print("UserDefaults - authentication 할당 오류")
            return
        }
        print("UserDefaults - authentication: \(authentication)")
        
        // POST 통신
        WillsonerRegisterServices.shared.postRegisterComplete(subCategoryIndex: subCategoryIndex, experience: experience, keywordIndex: keywordIndex, introduction: introduction, imageIndex: imageIndex, auth_licence: "", auth_media: "", auth_phone: "", auth_email: "") { registerComplete in
            self.registerComplete = registerComplete
            print(self.registerComplete ?? "")
            print("===============")
            print("헬퍼 등록 통신 성공")
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // navi bar right item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icX"), style: .plain, target: self, action: #selector(tappedBarButton(sender:)))
    }
    
    // MARK: - Methods
    @objc func tappedBarButton(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
}

