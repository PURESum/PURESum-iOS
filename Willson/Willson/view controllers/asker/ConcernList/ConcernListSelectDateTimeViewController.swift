//
//  ConcernListSelectDateTimeViewController.swift
//  Willson
//
//  Created by JHKim on 2019/12/22.
//

import UIKit
import FSCalendar

class ConcernListSelectDateTimeViewController: UIViewController {

    // MARK: - properties
    // 그레고리언 달력
    fileprivate let gregorian = Calendar(identifier: .gregorian)
    //날짜 형식을 "yyyy/mm/dd로 지정
    fileprivate lazy var dateFormatter1: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM"
        return formatter
    }()
    fileprivate lazy var dateFormatter2: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 dd일"
        return formatter
    }()
    fileprivate lazy var dateFormatter3: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd"
        return formatter
    }()
    
    // 월 이동 시
    var pageMonth: String?
    // 날짜 선택
    var selectDays: [String]?
    
    // MARK: - IBOutlet
    @IBOutlet weak var fsCalendar: FSCalendar!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var cancelBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var monthLabel: UILabel!
    @IBOutlet weak var preMonthButton: UIButton!
    @IBOutlet weak var nextMonthButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // fs calendar
        fsCalendar.delegate = self
        fsCalendar.dataSource = self
        fsCalendar.placeholderType = .fillHeadTail
//        fsCalendar.appearance.eventOffset = .init(x: 0, y: -29)
        fsCalendar.appearance.weekdayFont = UIFont(name: "AppleSDGothicNeo-Regular", size: 16)
        
        // 처음 로드 됐을 때 month label 적용
        pageMonth = dateFormatter1.string(from: Date())
        print("calendarCurrentPageDidChange - pageMonth: \(pageMonth ?? "")")
        monthLabel.text = pageMonth
    }
    
    // MARK: - Methods
}

extension ConcernListSelectDateTimeViewController: FSCalendarDelegate {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        /*
        let selectedDates = calendar.selectedDates
        
        for date in selectedDates {
            let day = dateFormatter2.string(from: date)
            self.selectDays?.append(day)
        }
         */
        let selectDay = dateFormatter2.string(from: date)
        print("didSelect date: \(selectDay)")
        
        guard let vc = UIStoryboard(name: "AskerConcernList", bundle: nil).instantiateViewController(withIdentifier: "ConcernListDatePickerPopUpViewController") as? ConcernListDatePickerPopUpViewController else {
            print("calendar didSelect: vc 할당 오류")
            return
        }
        vc.yearAndMonth = dateFormatter1.string(from: date)
        vc.date = dateFormatter3.string(from: date)
        // delegate
        vc.selectDateTimeDelegate = self
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    func calendar(_ calendar: FSCalendar, didDeselect date: Date, at monthPosition: FSCalendarMonthPosition) {
        let deselectDay = dateFormatter2.string(from: date)
        print("didDeselect date: \(deselectDay)")
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        let currentPageMonth = calendar.currentPage
        
        pageMonth = dateFormatter1.string(from: currentPageMonth)
        print("calendarCurrentPageDidChange - pageMonth: \(pageMonth ?? "")")
        monthLabel.text = pageMonth
        loadViewIfNeeded()
    }
}

// MARK: - FSCalendarDataSource
extension ConcernListSelectDateTimeViewController: FSCalendarDataSource {
    
}

// MARK: - FSCalendarDelegateAppearance
extension ConcernListSelectDateTimeViewController: FSCalendarDelegateAppearance {
    
}

// MARK: -
extension ConcernListSelectDateTimeViewController: SelectDateTimeDelegate {
    func didSelectedTime(fromDate: Date?, toDate: Date?) {
        guard let fromDate = fromDate else {
            print("didSelectedTime - fromDate 할당 오류")
            return
        }
        guard let toDate = toDate else {
            print("didSelecteTime = toDate 할당 오류")
            return
        }
        print("fromdate: \(fromDate), toDate: \(toDate)")
    }
}
