//
//  HelperApplicationEmailViewController.swift
//  Willson
//
//  Created by JHKim on 2019/11/13.
//

import UIKit

class HelperApplicationEmailViewController: UIViewController {

    // MARK: - properties
    var registerComplete: RegisterComplete?
    
    // MARK: - IBAction
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
        
        // keyboard hide - view tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tap)

        // navi bar right item
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icX"), style: .plain, target: self, action: #selector(tappedBarButton(sender:)))
    }
    
    // MARK: - Methods
    @objc func tappedBarButton(sender: UIBarButtonItem) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // 빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }

}
