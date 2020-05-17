//
//  HelperChatListViewController.swift
//  Willson
//
//  Created by JHKim on 11/10/2019.
//

import UIKit
import Kingfisher
import Firebase
import ObjectMapper

class HelperChatListViewController: UIViewController {
    
    // MARK: - propeties
    let headerCellIdentifier: String = "ChatListHeaderTableViewCell"
    let roomCellIdentifier: String = "ChatListRoomTableViewCell"
    
    // chatRoom response model
    var chatRoom: WillsonerChatRoom?
    var chatRoomData: WillsonerChatRoomData?
    var ing, reserve: [WillsonerIng]?
    
    // 채팅 - firestore
    var db: Firestore!
    // 리스너 선언
    var listener: ListenerRegistration!
    
    // time formatter
    let timeFormatter: DateFormatter = {
        let formatter: DateFormatter = DateFormatter()
        //        formatter.locale = Locale(identifier:"ko_KR")
        formatter.dateFormat = "a h:mm"
        return formatter
    }()
    
    // MARK: - IBOutlet
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var chatListTableView: UITableView!
    
    // MARK: - life cycle
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // navibar hidden
        navigationController?.setNavigationBarHidden(true, animated: animated)
        
        // chatRoomService - GET 통신
        getChatRoom()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // table view delegate, datasource
        chatListTableView.delegate = self
        chatListTableView.dataSource = self
        
        chatListTableView.separatorStyle = .none
        
        chatListTableView.sectionHeaderHeight = 74
        chatListTableView.rowHeight = 74
        
        // firestore
        // [START setup]
        let settings = FirestoreSettings()
        
        Firestore.firestore().settings = settings
        // [END setup]
        db = Firestore.firestore()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // 리스너 분리
        if listener != nil {
            listener.remove()
        }
        
        // navibar hidden false
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    // MARK: - Methods
    // 채팅방 목록
    // GET 통신
    func getChatRoom() {
        ChatServices.shared.willonerGetChatRooms { chatRoom in
            self.chatRoom = chatRoom
            self.chatRoomData = self.chatRoom?.data
            self.ing = self.chatRoomData?.ing
            self.reserve = self.chatRoomData?.reserve
            
            print("===================")
            print("채팅방 목록 통신 성공 (윌스너)")
            
            // 채팅방 개수 label
            guard let count = self.chatRoomData?.count else {
                print("self.chatRoomData?.count 할당 오류")
                return
            }
            self.countLabel.text = "\(count)"
            
            // reload
            self.view.reloadInputViews()
            self.chatListTableView.reloadData()
        }
    }
}

extension HelperChatListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            guard let vc: HelperChatRoomViewController = UIStoryboard(name: "HelperChat", bundle: nil).instantiateViewController(withIdentifier: "HelperChatRoomViewController") as? HelperChatRoomViewController else {
                print("vc: HelperChatRoomViewController 할당 오류")
                return
            }
            guard let roomkey = ing?[indexPath.row].roomkey else {
                print("didSelectRowAt: roomkey 할당 오류")
                return
            }
            vc.roomkey = roomkey
            guard let chatRoomDataRow = ing?[indexPath.row] else {
                print("didSelectRowAt: chatRoomDataRow 할당 오류")
                return
            }
            vc.chatRoomDataRow = chatRoomDataRow
            vc.hidesBottomBarWhenPushed = true
            
            navigationController?.pushViewController(vc, animated: true)
        case 1:
            break
        default:
            break
        }
    }
}

extension HelperChatListViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            if let count = ing?.count {
                return count
            } else {
                print("chatRoomData?.rows.count 할당 오류")
                return 0
            }
        case 1: return 0
        default: return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 74))
        guard let headerCell: ChatListHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier) as? ChatListHeaderTableViewCell else {
            print("ChatListHeaderTableViewCell 할당 오류")
            return UIView()
        }
        switch section {
        case 0:
            headerCell.titleLabel.text = "진행중인 상담"
        case 1:
            headerCell.titleLabel.text = "예약된 상담"
        default: break
        }
        headerCell.frame = CGRect(x: 0, y: 0, width: headerView.bounds.size.width, height: headerView.bounds.size.height)
        headerView.addSubview(headerCell)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 74
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell: ChatListRoomTableViewCell = tableView.dequeueReusableCell(withIdentifier: roomCellIdentifier, for: indexPath) as? ChatListRoomTableViewCell else { return UITableViewCell() }
            
            // 이미지
            /*
             guard let urlString = chatRoomData?.rows[indexPath.row].willsoner.image.pic else {
             print("이미지 url - hatRoomData?.rows[indexPath.row].willsoner.image.pic 할당 오류")
             return UITableViewCell()
             }
             let url = URL(string: urlString)
             cell.profileImageView.kf.setImage(with: url)
             */
            
            // 이름
            if let name = ing?[indexPath.row].concern?.asker?.nickname {
                cell.titleLabel.text = name
            }else {
                print("윌스너 이름 - ing?[indexPath.row].willsoner?.asker.nickname 할당 오류")
                cell.titleLabel.text = ""
            }
            
            if let roomkey = ing?[indexPath.row].roomkey {
                listener = db.collection("chatrooms").document(roomkey).collection("chats").order(by: "timeStamp", descending: true).limit(to: 1).addSnapshotListener { querySnapshot, error in
                    guard let snapshot = querySnapshot else {
                        print("Error fetching snapshots: \(error!)")
                        return
                    }
                    snapshot.documentChanges.forEach { diff in
                        // 메시지 가져와서 보여주기
                        if let comment: Comment = Mapper<Comment>().map(JSON: diff.document.data()) {
                            if diff.type == .modified || diff.type == .added {
                                print("modified or added: \(comment)")
                                
                                if comment.uid == "start" || comment.uid == "intro" || comment.uid == "end" {
                                    // 안내 문구
                                    cell.contentLabel.text = "대화를 시작해 보세요."
                                } else {
                                    // 내용 (최근 메시지)
                                    cell.contentLabel.text = comment.message
                                }
                            } else {
                                // 안내 문구
                                cell.contentLabel.text = "대화를 시작해 보세요."
                            }
                            
                            // 시간
                            // time
                            if let timeStamp = comment.timeStamp {
                                let time = self.timeFormatter.string(from: timeStamp.dateValue())
                                cell.timeLabel.text = time
                            } else {
                                let time = self.timeFormatter.string(from: Date())
                                cell.timeLabel.text = time
                            }
                        }
                    }
                }
            }
            
            // 개수
            // ** 임시 값
            cell.alertLabel.text = "N"
            
            cell.selectionStyle = .none
            return cell
        case 1:
            guard let cell: ChatListRoomTableViewCell = tableView.dequeueReusableCell(withIdentifier: roomCellIdentifier, for: indexPath) as? ChatListRoomTableViewCell else { return UITableViewCell() }
            cell.selectionStyle = .none
            return cell
        default:
            return UITableViewCell()
        }
    }
}
