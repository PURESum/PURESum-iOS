//
//  ConcernListApplyMethodsViewController.swift
//  Willson
//
//  Created by JHKim on 2019/12/30.
//

import UIKit
import Toast_Swift

class ConcernListApplyMethodsViewController: UIViewController {

    // MARK: - properties
    
    // MARK: - IBOutlet
    @IBOutlet weak var realtimeView: CustomView!
    @IBOutlet weak var realtimeLabel: UILabel!
    @IBOutlet weak var realtimeImageView: UIImageView!
    
    @IBOutlet weak var reservationView: CustomView!
    @IBOutlet weak var reservationLabel: UILabel!
    @IBOutlet weak var reservationImageView: UIImageView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        if realtimeView.tag == 1 {
            let vc = UIStoryboard(name: "AskerConcernList", bundle: nil).instantiateViewController(withIdentifier: "ConcernListAgreementViewController")
            // UserDefaults - type
            UserDefaults.standard.set("realtime", forKey: "type")
            guard let type = UserDefaults.standard.value(forKey: "type") else {
                print("UserDefaults - type 할당 오류")
                return
            }
            print("UserDefaults - type: \(type)")
            // 화면 전환 - 실시간 -> 동의 화면
            self.show(vc, sender: nil)
        } else if reservationView.tag == 1 {
            /*
            let vc = UIStoryboard(name: "AskerConcernList", bundle: nil).instantiateViewController(withIdentifier: "ConcernListSelectDateTimeViewController")
            // UserDefaults - type
            UserDefaults.standard.set("reserve", forKey: "type")
            guard let type = UserDefaults.standard.value(forKey: "type") else {
                print("UserDefaults - type 할당 오류")
                return
            }
            print("UserDefaults - type: \(type)")
            // 화면 전환 - 예약 -> 예약 화면
            self.show(vc, sender: nil)
            */
            // 임시
            self.view.makeToast("현재 버전은 실시간 매칭만 가능합니다.",
            duration: 3.0,
            position: .bottom,
             style: ToastStyle())
        }
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // realtime, reservation 뷰에 제스쳐 추가
        let realtimeGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedRealtimeView(_:)))
        let reservationGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedReservationView(_:)))
        realtimeView.addGestureRecognizer(realtimeGesture)
        reservationView.addGestureRecognizer(reservationGesture)
        
        // 처음에 다음 버튼 비활성화
        nextButton.isEnabled = false
    }

    // MARK: - Methods
    @objc func tappedRealtimeView(_ gesture: UITapGestureRecognizer) {
        if realtimeView.tag == 0 {
            realtimeView.tag = 1
            realtimeView.borderColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
            realtimeLabel.textColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
            realtimeImageView.image = UIImage(named: "icClockNavy")
            
            reservationView.tag = 0
            reservationView.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            reservationLabel.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            reservationImageView.image = UIImage(named: "icCalendarGray")
        } else {
            realtimeView.tag = 0
            realtimeView.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            realtimeLabel.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            realtimeImageView.image = UIImage(named: "icClockGray-1")
        }
        checkInfoFilled()
    }
    
    @objc func tappedReservationView(_ gesture: UITapGestureRecognizer) {
        if reservationView.tag == 0 {
            reservationView.tag = 1
            reservationView.borderColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
            reservationLabel.textColor = #colorLiteral(red: 0.1019607843, green: 0.1490196078, blue: 0.3137254902, alpha: 1)
            reservationImageView.image = UIImage(named: "icCalendarNavy")
            
            realtimeView.tag = 0
            realtimeView.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            realtimeLabel.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            realtimeImageView.image = UIImage(named: "icClockGray-1")
        } else {
            reservationView.tag = 0
            reservationView.borderColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            reservationLabel.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
            reservationImageView.image = UIImage(named: "icCalendarGray")
        }
        checkInfoFilled()
    }
    
    func checkInfoFilled() {
        if realtimeView.tag + reservationView.tag == 1 {
            nextButton.isEnabled = true
        } else {
            nextButton.isEnabled = false
        }
    }
}
