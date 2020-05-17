//
//  ConcernListWriteStoryViewController.swift
//  Willson
//
//  Created by JHKim on 06/10/2019.
//

import UIKit

class ConcernListWriteStoryViewController: UIViewController {
    
    // MARK: - properties
    let cellIdentifier: String = "ConcernListConcernTableViewCell"
    
    let concernArray: [String] = ["나중에 취업이 될 수 있을지 잘 모르겠어요.", "포트폴리오를 어떻게 만들어야 할 지 모르겠어요.", "자소서는 어떻게 써야 하나요?", "대학교 때 어떤 활동이 도움이 될까요?", "없음"]
    
    // MARK: - IBOutlet
    @IBOutlet weak var contentTextView: UITextView!
    @IBOutlet weak var textCountLabel: UILabel!
    
    @IBOutlet weak var touchView: UIView!
    
    @IBOutlet weak var oftenConcernTableView: UITableView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    // MARK: - IBAction
    @IBAction func tappedCancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tappedNextButton(_ sender: Any) {
        guard let content = contentTextView.text else {
            print("content TextField - text 할당 오류")
            return
        }
        
        // Userdefault - content 저장
        UserDefaults.standard.set(content, forKey: "content")
        
        guard let cont = UserDefaults.standard.value(forKey: "content") else {
            print("UserDefaults - content 할당 에러")
            return
        }
        print("UserDefaults - content: \(cont)")
    }
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // keyboard hide - view tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        touchView.addGestureRecognizer(tap)
        
        // tableview selection
        oftenConcernTableView.isUserInteractionEnabled = true
        oftenConcernTableView.allowsMultipleSelection = false
        
        // keyboard와 tablewview 함께 있을 때
        oftenConcernTableView.keyboardDismissMode = .onDrag
        
        // tableview delegate, datasource
        oftenConcernTableView.delegate = self
        oftenConcernTableView.dataSource = self
        
        // textview delegate
        contentTextView.delegate = self
        
        oftenConcernTableView.rowHeight = 55
        oftenConcernTableView.separatorStyle = .none
        
        // 처음에 버튼 비활성화
        nextButton.isEnabled = false
        
        // textview count
        if contentTextView.text != "내용을 입력해 주세요." {
            updateCharacterCount()
        } else { textCountLabel.text = "0" }
    }
    
    // MARK: - Methods
    func checkAllInfoFilled() {
        if textCountLabel.text != "0" { nextButton.isEnabled = true }
        else { nextButton.isEnabled = false }
    }
}

extension ConcernListWriteStoryViewController: UITextViewDelegate {
    
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
        if(textView == contentTextView) {
            return textView.text.count + (text.count - range.length) <= 300
        }
        return false
    }
    
    // 빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        touchView.endEditing(true)
        /*
        for scrollView in view.subviews {
            for view1 in scrollView.subviews {
                for view2 in view1.subviews {
                    for textView in view2.subviews {
                        if textView is UITextView {
                            textView.resignFirstResponder()
                        }
                    }
                }
            }
        }
        */
    }
    
    // 글자수 반영
    func updateCharacterCount() {
        let count = contentTextView.text.count
        self.textCountLabel.text = "\(count)"
    }
    
    // 텍스트뷰 set up
    func setUpTextView() {
        if contentTextView.text == "내용을 입력해 주세요." {
            contentTextView.text = ""
            contentTextView.textColor = #colorLiteral(red: 0.1568627451, green: 0.1568627451, blue: 0.1568627451, alpha: 1)
        } else if contentTextView.text == "" {
            contentTextView.text = "내용을 입력해 주세요."
            contentTextView.textColor = #colorLiteral(red: 0.8392156863, green: 0.8392156863, blue: 0.8392156863, alpha: 1)
        }
    }
}

extension ConcernListWriteStoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            print("selectedRows: \(selectedRows)")
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let selectedRows = tableView.indexPathsForSelectedRows {
            print("deSelectedRows: \(selectedRows)")
        }
    }
}

extension ConcernListWriteStoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return concernArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: ConcernListConcernTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ConcernListConcernTableViewCell else { return UITableViewCell() }
        
        cell.label.text = concernArray[indexPath.row]
        
        cell.delegate = self
        cell.delegate?.view.endEditing(true)
        
        cell.selectionStyle = .none
        cell.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        return cell
    }
    
}
