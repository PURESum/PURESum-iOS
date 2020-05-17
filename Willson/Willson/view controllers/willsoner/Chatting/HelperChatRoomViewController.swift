//
//  HelperChatRoomViewController.swift
//  Willson
//
//  Created by JHKim on 2019/11/17.
//

import UIKit
import Firebase
import ObjectMapper

class HelperChatRoomViewController: UIViewController {
    
    /*
     채팅방이 실행되었을 때의 순서
     1. intro 구문이 없을 때
     1. checkReadUser 메소드가 먼저 실행되면서 해당 roomkey에서 첫 문구를 두명 다 확인했는지 체크한다.
     **두명 모두 읽었을 경우 readUser의 size가 2이기 때문에 그 뒤의 메소드들은 실행되지 않는다.
     2. enterChatRoom 메소드가 실행되면서 해당 roomkey의 readUser에 본인의 uid를 추가한다.
     3. 추가완료된 후에 본인이 몇번째 들어온 사람인지 체크한다.
     **처음으로 들어온 사람이라면 그 다음 사람이 들어올 때 까지 기다린다.로 ( 이때 나가더라도 상관없음. 다만, snapshotlistner를 remove해주는 과정이 필요)
     4. 두명이 모두 들어오게되면 readUser에 두명의 uid가 모두 추가되면서 조건문을 통해 intro 문구가 추가된다. 완료 callback에 listener를 remove 해준다.
     2. intro 구문에서 둘 다 동의를 누르지 않았을 때
     1. 동의를 누르면 문구가 변하면서 해당 roomkey의 두번째 문구의 readUser에 uid가 추가된다.
     2.
     3. 상대를 기다린다.
     3. intro 구문에서 둘 다 동의를 눌렀을 때
     1. 대화를 시작하면서 listener를 제거해준다.
     */
    
    // MARK: - properties
    let announceCellIdentifier: String = "ChatAnnouncementTableViewCell"
    let agreementCellIdentifier: String = "ChatAgreementTableViewCell"
    let chatStartCellIdnetifier: String = "ChatStartTableViewCell"
    let userChatCellIdentifier: String = "UserChatTableViewCell"
    let otherChatCellIdentifier: String = "OtherChatTableViewCell"
    
    // chatting timer
    var timer = Timer()
    var count: Int?
    var timeStamp: Timestamp?
    
    // chatRoom response model
    var chatRoomDataRow: WillsonerIng?
    
    // roomkey
    var roomkey: String?
    // uid
    var uid: String?
    
    // 채팅 - firestore
    var db: Firestore!
    
    // 리스너 선언
    var listener: ListenerRegistration!
    // start
    var startListener: ListenerRegistration!
    // intro
    var introListener: ListenerRegistration!
    
    // chats
    var comments: [Comment]?
    
    // scroll to bottom
    var lastIndexPath: IndexPath?
    
    // time formatter
    let timeFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
//        formatter.locale = Locale(identifier:"ko_KR")
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
    @IBOutlet weak var chatRoomTableView: UITableView!
    
    @IBOutlet weak var timeBarButtonItem: UIBarButtonItem!
    
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: - IBAction
    @IBAction func tappedPlusButton(_ sender: Any) {
        
    }
    
    @IBAction func tappedSendButton(_ sender: Any) {
        guard let roomkey = self.roomkey else {
            print("roomkey가 nil값을 가짐")
            return
        }
        //        print("roomkey: \(roomkey)")
        guard let message = textField.text else {
            print("textfield가 비어 있음")
            return
        }
        //        print("message: \(message)")
        
        guard let uid = self.uid else {
            print("uid 할당 오류")
            return
        }
        //        print("uid: \(uid)")
        
        var ref: DocumentReference? = nil
        ref = db.collection("chatrooms").document(roomkey).collection("chats").addDocument(data: [
            "uid" : uid,
            "message" : message,
            "timeStamp" : FieldValue.serverTimestamp(),
            "readUser" : [
                self.uid : true
            ]
        ]) { err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
            }
        }
        /*
        self.chatRoomTableView.reloadData()
        DispatchQueue.main.async {
            let indexPath = IndexPath(row: (self.comments?.count ?? 0) - 1, section: 0)
            self.chatRoomTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
        */
        textField.text = ""
        setUpTextField()
    }
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // keyboard hide - view tapped
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewDidTapped(_:)))
        view.addGestureRecognizer(tap)
        
        // comment 초기화
        comments = []
        
        // tableview delegate, datasource
        chatRoomTableView.delegate = self
        chatRoomTableView.dataSource = self
        
        chatRoomTableView.separatorStyle = .none
        
        // textfield delegate
        textField.delegate = self
        // textfield 입력 감지 - 버튼 활성화
        textField.addTarget(self, action: #selector(textChange(_:)), for: .editingChanged)
        
        // set navigation bar title
        if let nickname = chatRoomDataRow?.concern?.asker?.nickname {
            self.title = "\(nickname) 님"
        } else {
            self.title = ""
        }
        
        // firestore
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
        
        // firestore
        startChat()
        
        // start
        checkReadUser()
        
        // 카카오 처리 - 숫자로된 아이디 값
        if let uid: String = UserDefaults.standard.value(forKey: "kakaoID") as? String {
            print("kakao id 할당")
            self.uid = uid
        } else {
            guard let uid = Auth.auth().currentUser?.uid else {
                print("enterChatRoom: uid 할당 오류")
                return
            }
            self.uid = uid
        }
        
        // 초기에 버튼 비활성화
        sendButton.isEnabled = false
        
        // count
        if let time: NSString = chatRoomDataRow?.concern?.time as NSString? {
            let count: Int = (time as NSString).integerValue
            self.count = count
        } else {
            self.count = 0
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 리스너 분리
        if listener != nil {
            listener.remove()
        }
        
        // 키보드 노티 분리
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // MARK: - Methods
    
     // tableview scroll
        func scrollToBottom(){
            DispatchQueue.main.async {
    //            let indexPath = IndexPath(row: self.lastRowInLastSection!, section: self.lastSection!)
                if let lastIndexPath: IndexPath = self.lastIndexPath {
                    self.chatRoomTableView.scrollToRow(at: lastIndexPath, at: .bottom, animated: true)
                }
            }
        }
    
    // chatting timer
    @objc func timeLimit() {
        let timerFormatter = DateFormatter()
        if let timeStamp = self.timeStamp {
            let date = Date(timeIntervalSince1970: timeStamp.dateValue().timeIntervalSince1970)
            if let count = self.count {
                var remainingSeconds: Int = count * 60 + Int(date.timeIntervalSinceNow)
                if remainingSeconds > 0 {
                    remainingSeconds -= 1
                    timeBarButtonItem.title = "\(remainingSeconds / 60):\(remainingSeconds % 60)"
                    timerFormatter.dateFormat = "mm:ss"
                    
                    if let formattime = timerFormatter.date(from:timeBarButtonItem.title ?? "") {
                        timeBarButtonItem.title = timerFormatter.string(from: formattime)
                    }
                } else {
                    timeLimitStop()
                }
            }
        }
    }
    
    func timeLimitStop() {
        timer.invalidate()
        
        // 동의 철회
        // UserDefault - key: roomkey
        self.navigationController?.popViewController(animated: true)
    }
    
    // firestore
    func startChat() {
        guard let roomkey = self.roomkey else {
            return
        }
        // 초기화
        listener = db.collection("chatrooms").document(roomkey).collection("chats").order(by: "timeStamp", descending: false).addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                if diff.type == .added {
                    
                    // 메시지 가져와서 보여주기
                    guard let comment: Comment = Mapper<Comment>().map(JSON: diff.document.data()) else {
                        print("startChat (.added) - Mapper<Comment>().map(JSONObject: value) 할당 오류")
                        return
                    }
                    print("added: \(comment)")
                    self.comments?.append(comment)
                    
                    if comment.uid == "end" {
                        if let timeStamp = comment.timeStamp {
                            // timestamp
                            self.timeStamp = timeStamp
                            print("uid == end: timeStamp 세팅 완료 !")
                            
                            // 타이머 시작
                            // set chatting timer
                            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeLimit), userInfo: nil, repeats: true)
                        }
                    }
                }
                self.chatRoomTableView.reloadData()
                let indexPath = NSIndexPath(row: (self.comments?.count ?? 0) - 1, section: 0)
                self.chatRoomTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
            }
        }
    }
    
    func checkReadUser() {
        guard let roomkey = self.roomkey else {
            print("checkReadUser: roomkey 할당 오류")
            return
        }
        db.collection("chatrooms").document(roomkey).collection("chats").document("start").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            guard let data = snapshot.data() else {
                print("checkReadUser: snapshot.data() 할당 오류")
                return
            }
            
            let start = Mapper<Comment>().map(JSON: data)
            if start != nil && start?.readUser?.count != 2 {
                guard let timeStamp = start?.timeStamp else {
                    print("checkReadUser: timeStamp 할당 오류")
                    return
                }
                self.enterChatRoom(timeStamp: timeStamp)
            }
        }
    }
    
    func enterChatRoom(timeStamp: Timestamp) {
        guard let roomkey = roomkey else {
            print("enterChatRoom: roomkey 할당 오류")
            return
        }
        
        // 카카오 처리 - 숫자로된 아이디 값
        if let uid: String = UserDefaults.standard.value(forKey: "kakaoID") as? String {
            print("kakao id 할당")
            self.uid = uid
        } else {
            guard let uid = Auth.auth().currentUser?.uid else {
                print("enterChatRoom: uid 할당 오류")
                return
            }
            self.uid = uid
        }
        
        var ref: DocumentReference? = nil
        ref = db.collection("chatrooms").document(roomkey).collection("chats").document("start")
        ref?.setData([
            "uid" : "start",
            "timeStamp" : timeStamp,
            "readUser" : [
                uid : true
            ]
        ], merge: true) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
                
                self.startMsgListener()
            }
        }
    }
    
    func startMsgListener() {
        guard let roomkey = roomkey else {
            print("StartMsg: roomkey 할당 오류")
            return
        }
        startListener = db.collection("chatrooms").document(roomkey).collection("chats").document("start").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            guard let data = snapshot.data() else {
                print("startMsgListener: snapshot.data() 할당 오류")
                return
            }
            
            if error != nil && snapshot.exists {
                print("Current data: \(String(describing: snapshot.data()))")
                
                let start = Mapper<Comment>().map(JSON: data)
                if start?.readUser?.count == 2 {
                    // 둘 다 대화방에 들어오게 되면 두번째 문구 넣어주기
                    self.db.collection("chatrooms").document(roomkey).collection("chats").document("intro").setData([
                        "uid": "intro",
                        "message": "",
                        "timeStamp": FieldValue.serverTimestamp()
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                            self.chatRoomTableView.reloadData()
                            let indexPath = NSIndexPath(row: (self.comments?.count ?? 0) - 1, section: 0)
                            self.chatRoomTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                        }
                    }
                    self.startListener.remove()
                }
            }
        }
    }
    
    func checkAgreement() {
        guard let roomkey = self.roomkey else {
            print("checkReadUser: roomkey 할당 오류")
            return
        }
        db.collection("chatrooms").document(roomkey).collection("chats").document("intro").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            guard let data = snapshot.data() else {
                print("checkAgreement: snapshot.data() 할당 오류")
                return
            }
            
            let intro = Mapper<Comment>().map(JSON: data)
            if intro != nil && intro?.readUser?.count != 2 {
                guard let timeStamp = intro?.timeStamp else {
                    print("checkAgreement: timeStamp 할당 오류")
                    return
                }
                self.makeAgreement(timeStamp: timeStamp)
            }
        }
    }
    
    func makeAgreement(timeStamp: Timestamp) {
        guard let roomkey = roomkey else {
            print("makeAgreement: roomkey 할당 오류")
            return
        }
        guard let uid = self.uid else {
            print("makeAgreement: uid 할당 오류")
            return
        }
        var ref: DocumentReference? = nil
        ref = db.collection("chatrooms").document(roomkey).collection("chats").document("intro")
        ref?.setData([
            "uid" : "intro",
            "timeStamp" : timeStamp,
            "readUser" : [
                uid : true
            ]
        ], merge: true) { err in
            if let err = err {
                print("Error updating document: \(err)")
                
            } else {
                print("Document successfully updated")
                self.comments?[1].readUser = [uid: true]
                self.chatRoomTableView.reloadData()
                let indexPath = NSIndexPath(row: (self.comments?.count ?? 0) - 1, section: 0)
                self.chatRoomTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                self.introMsgListener()
            }
        }
    }
    
    func introMsgListener() {
        guard let roomkey = roomkey else {
            print("StartMsg: roomkey 할당 오류")
            return
        }
        introListener = db.collection("chatrooms").document(roomkey).collection("chats").document("intro").addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            guard let data = snapshot.data() else {
                print("introMsgListener: snapshot.data() 할당 오류")
                return
            }
            
            if error == nil && snapshot.exists {
                print("Current data: \(String(describing: snapshot.data()))")
                
                let intro = Mapper<Comment>().map(JSON: data)
                if intro?.readUser?.count == 2 {
                    // 둘 다 대화방에 들어오게 되면 두번째 문구 넣어주기
                    self.db.collection("chatrooms").document(roomkey).collection("chats").document("end").setData([
                        "uid": "end",
                        "message": "",
                        "timeStamp": FieldValue.serverTimestamp()
                    ]) { err in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                            
                            // timestamp
                            self.timeStamp = Timestamp()
                            print("uid == end: timeStamp 세팅 완료 !")
                            
                            // 타이머 시작
                            // set chatting timer
                            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeLimit), userInfo: nil, repeats: true)
                            self.setUpTextField()
                            self.chatRoomTableView.reloadData()
                            let indexPath = NSIndexPath(row: (self.comments?.count ?? 0) - 1, section: 0)
                            self.chatRoomTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                        }
                    }
                    self.introListener.remove()
                }
            }
        }
    }
    
    @objc func tappedAgreementView(_ tapGesture: UITapGestureRecognizer) {
        print("tapped AgreementView!")
        
        checkAgreement()
    }
}

// MARK: - UITextFieldDelegate
extension HelperChatRoomViewController: UITextFieldDelegate {
    
    //빈 화면 탭했을 때 키보드 내리기
    @objc func viewDidTapped(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    // textfield 수정을 시작하고 나서 바로
    func textFieldDidBeginEditing(_ textField: UITextField) {
        setUpTextField()
        self.chatRoomTableView.reloadData()
        DispatchQueue.main.async {
            let indexPath = NSIndexPath(row: (self.comments?.count ?? 0) - 1, section: 0)
            self.chatRoomTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
        }
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
            self.bottomConstraint.constant = -keyboardHeight
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
extension HelperChatRoomViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let uid = comments?[indexPath.row].uid else {
            print("cellForRowAt: comments?[indexPath.row].uid 할당 오류")
            return 0
        }
        if uid == "start" {
            return 166
        } else if uid == "intro" {
            return 460
        } else if uid == "end" {
            return 75
        } else {
            return UITableView.automaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let uid = comments?[indexPath.row].uid else {
            print("cellForRowAt: comments?[indexPath.row].uid 할당 오류")
            return 0
        }
        if uid == "start" {
            return 166
        } else if uid == "intro" {
            return 460
        } else if uid == "end" {
            return 75
        } else {
            return UITableView.automaticDimension
        }
    }
}

// MARK: - UITableViewDataSource
extension HelperChatRoomViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let count = comments?.count else {
            print("numberOfRowsInSection: count 할당 오류")
            return 0
        }
        return count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let uid = comments?[indexPath.row].uid else {
            print("cellForRowAt: comments?[indexPath.row].uid 할당 오류")
            return UITableViewCell()
        }
        guard let userUid = self.uid else {
            print("cellForRowAt: user?.uid 할당 오류")
            return UITableViewCell()
        }
        
        // 1. start
        if uid == "start" {
            guard let cell: ChatAnnouncementTableViewCell = tableView.dequeueReusableCell(withIdentifier: announceCellIdentifier, for: indexPath) as? ChatAnnouncementTableViewCell else {
                print("CellForRowAt: announceCell 할당 오류")
                return UITableViewCell()
            }
            
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
        // 2. intro
        else if uid == "intro" {
            guard let cell: ChatAgreementTableViewCell = tableView.dequeueReusableCell(withIdentifier: agreementCellIdentifier, for: indexPath) as? ChatAgreementTableViewCell else {
                print("CellForRowAt: agreementCell 할당 오류")
                return UITableViewCell()
            }
            
            // agreement
//            cell.agreementView.tag = indexPath.row
            let agreementTapGesture = UITapGestureRecognizer(target: self, action: #selector(tappedAgreementView(_:)))
            cell.agreementView.addGestureRecognizer(agreementTapGesture)
            
            if let readUser = comments?[indexPath.row].readUser {
                guard let uid = self.uid else {
                    print("readUser - uid 할당 오류")
                    return UITableViewCell()
                }
                if readUser[uid] ?? false {
                    cell.agreementLabel.textColor = #colorLiteral(red: 0.4392156863, green: 0.4392156863, blue: 0.4392156863, alpha: 1)
                    cell.agreementDetailLabel.text = ""
                    cell.checkImageView.image = UIImage(named: "icCheckBoldBlue")
                }
            }
            
            // time
            if let timeStamp = comments?[indexPath.row].timeStamp {
                let time = timeFormatter.string(from: timeStamp.dateValue())
                cell.timeLabel.text = time
            } else {
                let time = timeFormatter.string(from: Date())
                cell.timeLabel.text = time
            }
            
            cell.selectionStyle = .none
            return cell
        }
        // 3. end
        else if uid == "end" {
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
        else if uid == userUid {
            // 내가 보낸 메시지
            guard let cell: UserChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: userChatCellIdentifier, for: indexPath) as? UserChatTableViewCell else {
                print("UserChatTableViewCell 할당 오류")
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
            
            // read
            cell.readLabel.isHidden = true
            
            cell.selectionStyle = .none
            return cell
        } else { // 받은 메시지 (상대방이 보낸 메시지)
            guard let cell: OtherChatTableViewCell = tableView.dequeueReusableCell(withIdentifier: otherChatCellIdentifier, for: indexPath) as? OtherChatTableViewCell else {
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
    }
}
