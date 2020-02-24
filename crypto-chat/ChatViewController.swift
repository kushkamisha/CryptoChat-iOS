//
//  MessagesViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/5/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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
    
    @IBAction func sendMsg(_ sender: Any) { sendMsg() }
    
    let userId: String = "1"
    var username: String = ""
    var selectedFriendId: String = ""
    var selectedFriendName: String = ""
    var chats: [Chat] = []
    var msgs: [Message] = []
    var socket: Socket!
    
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
                    let json = JSON(data)
                    self.username = json["username"].stringValue
                    
                    self.socket = Socket.init(userId: self.userId)
                    self.socket.connect()
                        .subscribe(onNext: { _ in
                            self.socket.requestUserChats()
                                .subscribe(onNext: { users in
                                    print("\n\nUsers:")
                                    print(users)
                                    for user in users {
//                                        "socketid": "TQKf_7op9g1JnLAHAAAW", "id": "5", "online": "Y", "username": "mark"
                                        self.chats.append(Chat(
                                            userId: user["id"]!,
                                            socketId: user["socketId"] ?? "",
                                            avatar: #imageLiteral(resourceName: "user-default"),
                                            chatType: #imageLiteral(resourceName: "free"),
                                            chatTypeSelected: #imageLiteral(resourceName: "free white"),
                                            username: user["username"]!
                                        ))
                                    }
                                    self.chatsTableView.reloadData()
                                })
                        })
                
                case .failure(let error):
                    print(error.localizedDescription)
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
        
        updateMessages()
        
        return true
    }

}
