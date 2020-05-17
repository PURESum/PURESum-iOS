//
//  HelperApplicationExperienceViewController.swift
//  Willson
//
//  Created by JHKim on 13/10/2019.
//

import UIKit

class HelperApplicationExperienceViewController: UIViewController {
    
    // MARK: - properties
    let cellIdentifier: String = "HelperHashTagTableViewCell"
    
//    var textFieldIndex: IndexPath = IndexPath()
    
    var textfieldFlag: Bool = false
    
    var keywords: [String] = ["", "", ""]
    
    // network response model
    var hashTag: HashTag?
    var hashTagData: [HashTagData]?
    
    // MARK: - IBOutlet
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var experienceTextView: UITextView!
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var hashTagTableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        guard let experience = experienceTextView.text else {
            print("experience TextField - text 할당 오류")
            return
        }
        
        // UserDefaults - experience, keywordIndex 저장
        UserDefaults.standard.set(experience, forKey: "experience")
        guard let exper = UserDefaults.standard.value(forKey: "experience") else {
            print("UserDefaults - experience 할당 에러")
            return
        }
        print("UserDefaults - experience: \(exper)")
        
        // POST 통신
        guard let categoryIndex: Int = UserDefaults.standard.value(forKey: "categoryIndex") as? Int else {
            print("UserDefaults - categoryIndex 할당 에러")
            return
        }
        print("UserDefaults - categoryIndex: \(categoryIndex)")
        
        WillsonerRegisterServices.shared.postHashTag(categoryIndex: categoryIndex, keywords: keywords) { hashTag in
            self.hashTag = hashTag
            self.hashTagData = self.hashTag?.data
            
            print("================")
            print("윌스너 해시태그 통신 성공 !")
            print("\(String(describing: self.hashTag))")
            
            var keywordIndexes: [Int] = []
            if let hashTagData = self.hashTagData {
                for hashtag in hashTagData {
                    keywordIndexes.append(hashtag.idx)
                }
                UserDefaults.standard.set(keywordIndexes, forKey: "keywordIndex")
                guard let keyword: [Int] = UserDefaults.standard.value(forKey: "keywordIndex") as? [Int] else {
                    print("UserDefaults - keywordIndex 할당 에러")
                    return
                }
                print("UserDefaults - keywordIndex: \(keyword)")
                
                let vc = UIStoryboard(name: "HelperApplication", bundle: nil).instantiateViewController(withIdentifier: "HelperApplicationImageSelectViewController")
                self.navigationController?.show(vc, sender: nil)
            }
        }
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // keyboard nitificationCenter
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // keyboard hide - view tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tap)
        
        // tableview delegate, datasource
        hashTagTableView.delegate = self
        hashTagTableView.dataSource = self
        
        hashTagTableView.rowHeight = 56
        hashTagTableView.separatorStyle = .none

        // 선택 못하게
        hashTagTableView.allowsSelection = false
        
        // textview delegate
        experienceTextView.delegate = self
        
        // 처음에 버튼 비활성화
        nextButton.isEnabled = false
        
        // textview count
        if experienceTextView.text != "내용을 입력해 주세요." {
            updateCharacterCount()
        } else { countLabel.text = "0" }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 키보드 노티 분리
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    // MARK: - Methods
    func checkAllInfoFilled() {
        if countLabel.text != "0" {
            for keyword in keywords {
                if keyword == "" {
                    nextButton.isEnabled = false
                    break
                } else {
                    nextButton.isEnabled = true
                }
            }
        } else { nextButton.isEnabled = false }
    }
}

extension HelperApplicationExperienceViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        setUpTextView()
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            setUpTextView()
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        updateCharacterCount()
        checkAllInfoFilled()
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (textView == experienceTextView) {
            return textView.text.count + (text.count - range.length) <= 300
        }
        return false
    }
    
    // 빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // 글자수 반영
    func updateCharacterCount() {
        let count = experienceTextView.text.count
        self.countLabel.text = "\(count)"
    }
    
    // 텍스트뷰 set up
    func setUpTextView() {
        if experienceTextView.text == "내용을 입력해 주세요." {
            experienceTextView.text = ""
            experienceTextView.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        } else if experienceTextView.text == "" {
            experienceTextView.text = "내용을 입력해 주세요."
            experienceTextView.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        }
    }
}

extension HelperApplicationExperienceViewController: UITextFieldDelegate {

    // textfield 수정을 시작하고 나서 바로
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setUpTextField(textField)
        textfieldFlag = true
    }
    
    // textfield 수정이 끝나고 나서 바로
    func textFieldDidEndEditing(_ textField: UITextField) {
        setUpTextField(textField)
        textfieldFlag = false
    }
    
    // textfield set up
    func setUpTextField(_ textField: UITextField) {
        guard let cell: HelperHashTagTableViewCell = tableView(hashTagTableView, cellForRowAt: IndexPath(row: textField.tag, section: 0)) as? HelperHashTagTableViewCell else {
            print("textField Did Begin Editing: cell 할당 오류")
            return
        }
        if cell.textField.text == "+ 추가하기" {
            cell.textField.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
            cell.textField.text = ""
            checkAllInfoFilled()
        } else {
            cell.textField.textColor = #colorLiteral(red: 0.7215686275, green: 0.7215686275, blue: 0.7215686275, alpha: 1)
            cell.textField.text = "+ 추가하기"
            checkAllInfoFilled()
        }
    }
    
    // textfield 입력 감지 - 버튼 활성화
    @objc func textChange(_ textField: UITextField) {
        updateKeyword(textField)
        checkAllInfoFilled()
    }
    
    // 글자수 반영
    func updateKeyword(_ textField: UITextField) {
        if let keyword = textField.text {
            keywords[textField.tag] = keyword
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
//        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        //           let tabbarHeight = tabBarController?.tabBar.frame.size.height ?? 0
//        let keyboardHeight: CGFloat = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        if textfieldFlag {
            UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            //            self.bottomConstraint.constant = +keyboardHeight
                        self.scrollView.contentOffset = CGPoint(x: 0, y: 320)
                    })
                    self.view.layoutIfNeeded()
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        if textfieldFlag {
            UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            //            self.bottomConstraint.constant = 0
                        self.scrollView.contentOffset = CGPoint(x: 0, y: 180)
                    })
                    
                    self.view.layoutIfNeeded()
        }
    }
    
    /* tablew view cell scroll
    // textfield 수정을 시작하고 나서 바로
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hashTagTableView.scrollToRow(at: IndexPath(row: textField.tag, section: 0), at: .top, animated: true)
        guard let cell: HelperHashTagTableViewCell = tableView(hashTagTableView, cellForRowAt: textFieldIndex) as? HelperHashTagTableViewCell else {
            print("textField Did Begin Editing: cell 할당 오류")
            return
        }
        let offset = hashTagTableView.contentOffset.y - cell.frame.origin.y
        for cell in hashTagTableView.visibleCells {
            UIView.animate(withDuration: 0.3, animations: {
                cell.frame = cell.frame.offsetBy(dx: 0, dy: offset)
            })
        }
        hashTagTableView.isScrollEnabled = false
    }
    
    // textfield 수정이 끝나고 나서 바로
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let cell: HelperHashTagTableViewCell = tableView(hashTagTableView, cellForRowAt: textFieldIndex) as? HelperHashTagTableViewCell else {
            print("textField Did End Editing: cell 할당 오류")
            return
        }
        let offset = hashTagTableView.contentOffset.y - cell.frame.origin.y
        for cell in hashTagTableView.visibleCells {
            UIView.animate(withDuration: 0.3, animations: {
                cell.frame = cell.frame.offsetBy(dx: 0, dy: -offset)
            })
        }
        hashTagTableView.isScrollEnabled = true
    }
     */
}

extension HelperApplicationExperienceViewController: UITableViewDelegate {
}

extension HelperApplicationExperienceViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: HelperHashTagTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HelperHashTagTableViewCell else {
            print("helper hash tag tableview cell 할당 오류")
            return UITableViewCell()
        }
        
        // textfield delegate
        cell.textField.delegate = self
        cell.textField.tag = indexPath.row
        cell.textField.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
        
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return cell
    }
}
