//
//  SignUpAgeViewController.swift
//  Willson
//
//  Created by JHKim on 2020/05/12.
//

import UIKit

protocol SelectAgeDelegate: class {
    func didSelectedAge(age: String?)
}

class SignUpAgeViewController: UIViewController {

    // MARK: - properties
    let ageArray: [String] = ["2001", "2000", "1999", "1998", "1997", "1996", "1995", "1994", "1993", "1992", "1991", "1990", "1989", "1988", "1987", "1986", "1985", "1984", "1983", "1982", "1981", "1980", "1979", "1978", "1977", "1976", "1975"]
    
    // dismiss delegate
    var selectedAgeDelegate: SelectAgeDelegate?
    
    // MARK: - IBOutlet
    @IBOutlet weak var xButton: UIButton!
    
    @IBOutlet weak var pickerView: UIPickerView!
    
    // MARK: - IBAction
    @IBAction func tappedXButton(_ sender: Any) {
        selectedAgeDelegate?.didSelectedAge(age: nil)
        self.dismiss(animated: false, completion: nil)
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // picker view delegate
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    // MARK: - Methods
}

// MARK: - UIPickerViewDelegate
extension SignUpAgeViewController: UIPickerViewDelegate {
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // delegate 로 dissmiss 시 값 넘기기
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.selectedAgeDelegate?.didSelectedAge(age: self.ageArray[row])
            self.dismiss(animated: false, completion: nil)
        }
    }
}

// MARK: - UIPickerViewDataSource
extension SignUpAgeViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return ageArray.count
    }
    
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(ageArray[row])년생"
    }
}
