//
//  MessagesViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/5/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit
import Alamofire

struct LoadChats: Encodable {
    let userId: Int
}

class ChatViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchUserBar: UISearchBar!
    @IBOutlet weak var chatsTableView: UITableView!
    @IBOutlet weak var msgsTableView: UITableView!
    
    @IBOutlet weak var topBarUsername: UILabel!
    @IBOutlet weak var topBarAvatar: UIImageView!
    @IBOutlet weak var topBarChatType: UIImageView!
    
    @IBOutlet weak var sendMessageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    
    @IBAction func sendMsg(_ sender: Any) {
        sendMsg()
    }
    
    let userId: String = "1"
    
    var chats: [Chat] = []
    var msgs: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarBackgroundColor(color : UIColor.init(red: 122/255, green: 140/255, blue: 255/255, alpha: 1))
        
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        msgsTableView.delegate = self
        msgsTableView.dataSource = self
        sendMessageTextField.delegate = self
        
        msgsTableView.rowHeight = UITableView.automaticDimension
        
        chatsTableView.rowHeight = 75
        sendMessageTextField.attributedPlaceholder = NSAttributedString(string: "Type your message here...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)])
        
        loadChats()
    }
    
    func loadChats() {
        let params: [String: String] = [
            "userId": self.userId,
        ]
        
        AF.request("http://localhost:3000/userSessionCheck",
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            switch response.result {
                case .success(let data):
                    print(response)
                    let socket = Socket.init(userId: 1)
                    socket.connect()
                        .subscribe(onNext: { _ in
                            socket.requestUserChats()
                            .subscribe(onNext: { userList in
                                for user in userList {
                                    self.chats.append(Chat(userId: user["id"] ?? "", avatar: #imageLiteral(resourceName: "user-default"), chatType: #imageLiteral(resourceName: "free"), chatTypeSelected: #imageLiteral(resourceName: "free white"), username: user["username"] ?? "", message: "Do you know what does word \"thief\" mean?", msgTime: "just now"))
                                }
                                self.chatsTableView.reloadData()
                            })
                        })
                
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func getMessages(friendId: String) -> Future<[Dictionary<String, String>]> {
        return Future { completion in
            let params: [String: String] = [
                "userId": self.userId,
                "toUserId": friendId
            ]
            AF.request("http://localhost:3000/getMessages",
                       method: .post,
                       parameters: params,
                       encoder: JSONParameterEncoder.default).responseJSON { response in
                switch response.result {
                    case .success(let data):
                        let messages = (data as! NSDictionary)["messages"] as! NSArray
                        var msgList = [[String: String]]()
                        for msg in messages {
                            let m = msg as! NSDictionary
                            var tmp = [String: String]()
                            
                            tmp["msgId"] = "\(m["id"] as! Int)"
                            tmp["fromUserId"] = m["fromUserId"] as? String
                            tmp["toUserId"] = m["toUserId"] as? String
                            tmp["message"] = m["message"] as? String
                            
                            msgList.append(tmp)
                        }
                        
                        completion(.success(msgList))
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    
    // A new msg is entered in the send text field
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return sendMsg()
    }
    
    func sendMsg() -> Bool {
        let toSend = sendMessageTextField.text
        
        if (toSend == "") { return true }
        
        // Current time
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minutes = calendar.component(.minute, from: date)
        
        msgs.append(Message(userId: self.userId, msg: toSend ?? "", time: "\(hour):\(minutes)"))
        
        sendMessageTextField.text = ""
        
        msgsTableView.reloadData()
        
        return true
    }

}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == msgsTableView ? msgs.count : chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == chatsTableView) {
            let chat = chats[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
            cell.setChat(chat: chat)
            
            cell.selectionColor = UIColor.init(red: 122/255, green: 140/255, blue: 255/255, alpha: 1)
            
            return cell
        }
        
        let msg = msgs[indexPath.row]
        if (msg.userId == self.userId) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageRightCell") as! MessageRightCell
            cell.setMessage(message: msg)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MessageLeftCell") as! MessageLeftCell
            cell.setMessage(message: msg)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (tableView == chatsTableView) {
            let friendId = chats[indexPath.row].userId
            getMessages(friendId: friendId)
                .subscribe(onNext: { msgList in
                    self.msgs = []
                    for msg in msgList {
                        self.msgs.append(Message(userId: msg["fromUserId"] ?? "", msg: msg["message"] ?? "", time: "xx:xx"))
                    }
                    self.msgsTableView.reloadData()
                })
            
            topBarUsername.text = chats[indexPath.row].username
            topBarAvatar.image = chats[indexPath.row].avatar
            topBarChatType.image = chats[indexPath.row].chatTypeSelected
        }
    }
    
}
