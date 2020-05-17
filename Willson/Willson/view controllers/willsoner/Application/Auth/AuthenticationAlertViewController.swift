//
//  AuthenticationAlertViewController.swift
//  Willson
//
//  Created by JHKim on 2019/11/10.
//

import UIKit

class AuthenticationAlertViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    // MARK: - properties
    lazy var imagePicker: UIImagePickerController = { //이미지 피커 컨트롤러 생성
        let picker: UIImagePickerController = UIImagePickerController()
        picker.sourceType = .camera //이미지 소스로 사진 라이브러리 선택
        picker.allowsEditing = true //편집 허용
        cameraButtonView.layer.masksToBounds = true
        picker.delegate = self
        return picker
    }()
    
    // MARK: - IBOutlet
    @IBOutlet weak var alertView: UIView!
    
    @IBOutlet weak var cameraButtonView: UIView!
    
    // MARK: - IBAction
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // camera button view action
        let cameraButtonGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedCameraButton(_:)))
        cameraButtonView.addGestureRecognizer(cameraButtonGesture)
    }
    
    // MARK: - Methods
    @objc func tappedCameraButton(_ tapGesture: UITapGestureRecognizer) {
        // 이미지 피커 컨트롤러 실행
        self.present(self.imagePicker, animated: true, completion: nil)
        print("Select image from photo library")
    }
}
