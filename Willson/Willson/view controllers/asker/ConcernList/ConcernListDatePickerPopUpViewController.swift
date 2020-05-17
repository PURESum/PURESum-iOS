//
//  ConcernListDatePickerPopUpViewController.swift
//  Willson
//
//  Created by JHKim on 2020/03/16.
//

import UIKit
import Toast_Swift

protocol SelectDateTimeDelegate: class {
    func didSelectedTime(fromDate: Date?, toDate: Date?)
}
class ConcernListDatePickerPopUpViewController: UIViewController {

    // MARK: - properties
    var yearAndMonth: String?
    var date: String?
    var startTime: Date?
    var endTime: Date?
    
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "aa hh:mm"
        return formatter
    }()
    fileprivate lazy var hourFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh"
        return formatter
    }()
    fileprivate lazy var minuteFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter
    }()
    
    var selectedStartView: Bool = true
    
    // dismiss delegate
    var selectDateTimeDelegate: SelectDateTimeDelegate?
    
    // MARK: - IBOutlet
    // 시작 날짜 / 시간
    @IBOutlet weak var startView: UIView!
    @IBOutlet weak var startTitleLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var startMonthLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    
    // 종료 날짜 / 시간
    @IBOutlet weak var endView: UIView!
    @IBOutlet weak var endTitleLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var endMonthLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    
    // date picker
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // button
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var completeButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        selectDateTimeDelegate?.didSelectedTime(fromDate: nil, toDate: nil)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedCompleteButton(_ sender: Any) {
        guard let startTime = startTime else {
            print("tappedCompleteButton: startTime 할당 오류")
            return
        }
        guard let endTime = endTime else {
            print("tappedCompleteButton: endTime 할당 오류")
            return
        }
        print("startTime: \(startTime), endTime: \(endTime)")
        selectDateTimeDelegate?.didSelectedTime(fromDate: startTime, toDate: endTime)
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // date picker
        datePicker.addTarget(self, action: #selector(changedDatePicker(_:)), for: .valueChanged)
        
        // setUp
        setUp()
        
        // start / end view
        let startViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedStartView(_:)))
        startView.addGestureRecognizer(startViewTapGesture)
        let endViewTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedEndView(_:)))
        endView.addGestureRecognizer(endViewTapGesture)
        
        // 초기엔 시작 뷰 선택
        selectedStartView = true
    }

    // MARK: - methods
    // 셋 업
    func setUp() {
        datePicker.minuteInterval = 30
        datePicker.date = Date(timeInterval: 3600, since: Date().rounded(minutes: 30, rounding: .floor))
        
        startDateLabel.text = date
        startMonthLabel.text = yearAndMonth
        startTime = datePicker.date.rounded(minutes: 30, rounding: .floor)
        guard let startTime = startTime else {
            print("setUp: startTime 할당 오류")
            return
        }
        startTimeLabel.text = dateFormatter1.string(from: startTime)
        
        endDateLabel.text = date
        endMonthLabel.text = yearAndMonth
        endTime = datePicker.date.addingTimeInterval(3600).rounded(minutes: 30, rounding: .floor)
        guard let endTime = endTime else {
            print("setUp: endTime 할당 오류")
            return
        }
        endTimeLabel.text = dateFormatter1.string(from: endTime)
        
    }
    
    // 데이트 피커 변할 때
    @objc func changedDatePicker(_ picker: UIDatePicker) {
        if selectedStartView {
            // 종료 시간에 시간 추가
            guard let changedTime = startTime?.timeIntervalSince(datePicker.date) else {
                print("changedDatePicker: chnagedTime 할당 오류")
                return
            }
            endTime = endTime?.addingTimeInterval(-changedTime)
            
            guard let endTime = endTime else {
                print("changedDatePicker: endTime 할당 오류 1")
                return
            }
            endTimeLabel.text = dateFormatter1.string(from: endTime)
            
            // start label
            startTime = datePicker.date
            guard let startTime = startTime else {
                print("changedDatePicker: startTime 할당 오류")
                return
            }
            startTimeLabel.text = dateFormatter1.string(from: startTime)
            
            // 현재 시간 이전으로 선택 못하도록
            /*
            if datePicker.date == Date().rounded(minutes: 30, rounding: .floor) {
                
                self.view.makeToast("현재 시간 이후로 선택해주세요.",
                duration: 2.0,
                position: .bottom,
                 style: ToastStyle())
            } else {
                
            }
             */
        } else {
            // end label
            endTime = datePicker.date
            guard let endTime = endTime else {
                print("changedDatePicker: endTime 할당 오류 2")
                return
            }
            endTimeLabel.text = dateFormatter1.string(from: endTime)
            
            // 시작 시간 이전으로 설정 못하도록
        }
    }
    
    // 시작 시간 설정 시
    @objc func tappedStartView(_ gesture: UITapGestureRecognizer) {
        selectedStartView = true
        // 시작 뷰
        startTitleLabel.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        startDateLabel.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        startMonthLabel.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        startTimeLabel.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        // 종료 뷰
        endTitleLabel.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        endDateLabel.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        endMonthLabel.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        endTimeLabel.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        
        // date picker setup
        guard let startTime = startTime else {
            print("tappedStartView: startTime 할당 오류")
            return
        }
        datePicker.date = startTime
        
        // 현재 시간 이전으로 선택 못하도록
        /*
        var components: DateComponents = DateComponents()
        components.hour = Int(hourFormatter.string(from: Date()))
        components.minute = Int(minuteFormatter.string(from: Date()))
        let minDate: Date = Calendar(identifier: Calendar.Identifier.gregorian).date(byAdding: components, to: Date()) ?? Date()
        print("minDate: \(minDate)")
        datePicker.minimumDate = minDate
        components.hour = 23
        components.minute = 00
        let maxDate: Date = Calendar(identifier: Calendar.Identifier.gregorian).date(byAdding: components, to: Date()) ?? Date()
        print("maxDate: \(maxDate)")
        datePicker.maximumDate = maxDate
    */
    }
    
    // 종료 시간 설정 시
    @objc func tappedEndView(_ gesture: UITapGestureRecognizer) {
        selectedStartView = false
        // 시작 뷰
        startTitleLabel.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        startDateLabel.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        startMonthLabel.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        startTimeLabel.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        // 종료 뷰
        endTitleLabel.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        endDateLabel.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        endMonthLabel.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        endTimeLabel.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        
        // date picker setup
        guard let endTime = endTime else {
            print("tappedEndView: endTime 할당 오류")
            return
        }
        datePicker.date = endTime
        
        // 시작 시간 이전으로 설정 못하도록
        /*
        guard let startTime = startTime else {
            print("tappedEndView: startTime 할당 오류")
            return
        }
        var components: DateComponents = DateComponents()
        components.hour = Int(hourFormatter.string(from: startTime))
        components.minute = Int(minuteFormatter.string(from: startTime))
        let minDate: Date = Calendar(identifier: Calendar.Identifier.gregorian).date(byAdding: components, to: Date()) ?? Date()
        print("minDate: \(minDate)")
        datePicker.minimumDate = minDate
        components.hour = 24
        components.minute = 00
        let maxDate: Date = Calendar(identifier: Calendar.Identifier.gregorian).date(byAdding: components, to: Date()) ?? Date()
        print("maxDate: \(maxDate)")
        datePicker.maximumDate = maxDate
         */
    }
}

enum DateRoundingType {
    case round
    case ceil
    case floor
}

extension Date {
    func rounded(minutes: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        return rounded(seconds: minutes * 60, rounding: rounding)
    }
    func rounded(seconds: TimeInterval, rounding: DateRoundingType = .round) -> Date {
        var roundedInterval: TimeInterval = 0
        switch rounding  {
        case .round:
            roundedInterval = (timeIntervalSinceReferenceDate / seconds).rounded() * seconds
        case .ceil:
            roundedInterval = ceil(timeIntervalSinceReferenceDate / seconds) * seconds
        case .floor:
            roundedInterval = floor(timeIntervalSinceReferenceDate / seconds) * seconds
        }
        return Date(timeIntervalSinceReferenceDate: roundedInterval)
    }
}

