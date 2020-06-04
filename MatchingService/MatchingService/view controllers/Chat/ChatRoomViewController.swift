//
//  ChatRoomViewController.swift
//  MatchingService
//
//  Created by JHKim on 2020/05/24.
//  Copyright © 2020 zhi. All rights reserved.
//

import UIKit

class ChatRoomViewController: UIViewController {

    // MARK: - properties
    let chatStartCellIdnetifier: String = "ChatStartTableViewCell"
    let userChatCellIdentifier: String = "UserChatTableViewCell"
    let otherChatCellIdnetifier: String = "OtherChatTableViewCell"
    
    // roomkey
    var roomkey: String?
    // uid
    var uid: String?
    
    // 채팅 - firestore
//    var db: Firestore!
    // 리스너 선언
//    var listener: ListenerRegistration!
    
    // chats
    var comments: [Comment]?
    
    // scroll to bottom
    var lastIndexPath: IndexPath?
    
    // time formatter
    let timeFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        return formatter
    }()
    
    // date formatter
    let dateFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "M월 dd일 (E)"
        return formatter
    }()
    
    // MARK: - IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    // MARK: - IBAction
    
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
        
        // tableview delegate, dataSource
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 리스너 분리
        /*
        if listener != nil {
            listener.remove()
        }
        */
        
        // 키보드 노티 분리
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // MARK: - Methods
}

// MARK: - UITextFieldDelegate
extension ChatRoomViewController: UITextFieldDelegate {
    
    //빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // textfield 수정을 시작하고 나서 바로
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setUpTextField()
        /*
        self.tableView.reloadData()
        DispatchQueue.main.async {
            let indexPath = NSIndexPath(row: (self.comments?.count ?? 0) - 1, section: 0)
            self.tableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
        */
    }
    
    // textfield 수정이 끝나고 나서 바로
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == "" {
            setUpTextField()
        }
    }
    
    // textfield set up
    func setUpTextField() {
        if textField.text == "" {
            sendButton.isEnabled = false
        } else {
            // textField control - 동의 이전에는 입력 못하도록
            if let comments = self.comments {
                for comment in comments {
                    if comment.uid == "end" {
                        self.sendButton.isEnabled = true
                        break
                    } else {
                        self.sendButton.isEnabled = false
                    }
                }
            }
        }
    }
    
    // textfield 입력 감지 - 버튼 활성화
    @objc func textChange(_ textField: UITextField) {
        if textField.hasText {
            // textField control - 동의 이전에는 입력 못하도록
            if let comments = self.comments {
                for comment in comments {
                    if comment.uid == "end" {
                        self.sendButton.isEnabled = true
                        break
                    } else {
                        self.sendButton.isEnabled = false
                    }
                }
            }
        } else { sendButton.isEnabled = false }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else { return }
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else { return }
        
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        
        //           let tabbarHeight = tabBarController?.tabBar.frame.size.height ?? 0
        
        let keyboardHeight: CGFloat = keyboardFrame.cgRectValue.height - self.view.safeAreaInsets.bottom
        
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            self.bottomConstraint.constant = +keyboardHeight
        })
        self.view.layoutIfNeeded()
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        guard let duration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double else {return}
        guard let curve = notification.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt else {return}
        UIView.animate(withDuration: duration, delay: 0.0, options: .init(rawValue: curve), animations: {
            self.bottomConstraint.constant = 0
        })
        
        self.view.layoutIfNeeded()
    }
}

// MARK: - UITableViewDelegate
extension ChatRoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /*
        guard let uid = comments?[indexPath.row].uid else {
            print("heightForRowAt: comments?[indexPath.row].uid 할당 오류")
            return 0
        }
        if uid == "end" {
            return 75
        } else {
            return UITableView.automaticDimension
        }
        */
        switch indexPath.row {
        case 0:
            return 75
        default:
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        /*
        guard let uid = comments?[indexPath.row].uid else {
            print("estimatedHeightForRowAt: comments?[indexPath.row].uid 할당 오류")
            return 0
        }
        if uid == "end" {
            return 75
        } else {
            return UITableView.automaticDimension
        }
        */
        switch indexPath.row {
        case 0:
            return 75
        default:
            return UITableView.automaticDimension
        }
    }
}

// MARK: - UITableViewDataSource
extension ChatRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        /*
        guard let count = comments?.count else {
            print("numberOfRowsInSection: count 할당 오류")
            return 0
        }
        return count
        */
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.row {
        case 0:
            guard let cell: ChatStartTableViewCell = tableView.dequeueReusableCell(withIdentifier: chatStartCellIdnetifier, for: indexPath) as? ChatStartTableViewCell else {
                print("CellForRowAt: start cell 할당 오류")
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell: UserChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: userChatCellIdentifier, for: indexPath) as? UserChatTableViewCell else {
                print("UserChatTableViewCell 할당 오류")
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
        case 2:
            guard let cell: OtherChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: otherChatCellIdnetifier, for: indexPath) as? OtherChatTableViewCell else {
                print("OtherChatTableViewCell 할당 오류")
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            return cell
            
        default: return UITableViewCell()
        }
        /*
        guard let uid = comments?[indexPath.row].uid else {
            print("cellForRowAt: comments?[indexPath.row].uid 할당 오류")
            return UITableViewCell()
        }
        guard let userUid = self.uid else {
            print("cellForRowAt: user?.uid 할당 오류")
            return UITableViewCell()
        }
        
        if uid == "end" {
            guard let cell: ChatStartTableViewCell = tableView.dequeueReusableCell(withIdentifier: chatStartCellIdnetifier, for: indexPath) as? ChatStartTableViewCell else {
                print("CellForRowAt: start cell 할당 오류")
                return UITableViewCell()
            }
            
            // date
            if let timeStamp = comments?[indexPath.item].timeStamp {
                let time = dateFormatter.string(from: timeStamp.dateValue())
                cell.dateLabel.text = time
            } else {
                let time = dateFormatter.string(from: Date())
                cell.dateLabel.text = time
            }
            
            cell.selectionStyle = .none
            return cell
        }
        // 4. 대화 내용
        else if uid == userUid { // 내가 보낸 메시지
            guard let cell: UserChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: userChatCellIdentifier, for: indexPath) as? UserChatTableViewCell else {
                print("UserChatTableViewCell 할당 오류")
                return UITableViewCell()
            }
            
            // message
            guard let message = comments?[indexPath.row].message else {
                print("User - commnets?[indexPath.row].message 할당 오류")
                return UITableViewCell()
            }
            cell.messageLabel.text = message
            
            // time
            if let timeStamp = comments?[indexPath.item].timeStamp {
                let time = timeFormatter.string(from: timeStamp.dateValue())
                cell.timeLabel.text = time
            } else {
                let time = timeFormatter.string(from: Date())
                cell.timeLabel.text = time
            }
            
            // read
            cell.readLabel.isHidden = true
            
            cell.selectionStyle = .none
            return cell
        } else { // 받은 메시지 (상대방이 보낸 메시지)
            guard let cell: OtherChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: otherChatCellIdnetifier, for: indexPath) as? OtherChatTableViewCell else {
                print("OtherChatTableViewCell 할당 오류")
                return UITableViewCell()
            }
            
            // message
            guard let message = comments?[indexPath.item].message else {
                print("User - commnets?[indexPath.item].message 할당 오류")
                return UITableViewCell()
            }
            cell.messageLabel.text = message
            
            // time
            if let timeStamp = comments?[indexPath.item].timeStamp {
                let time = timeFormatter.string(from: timeStamp.dateValue())
                cell.timeLabel.text = time
            } else {
                let time = timeFormatter.string(from: Date())
                cell.timeLabel.text = time
            }
            
            cell.selectionStyle = .none
            return cell
        }
 */
    }
}

