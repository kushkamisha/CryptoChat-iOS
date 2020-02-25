//
//  MessagesViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/5/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit


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
    
    let userId: String = "1"
    var username: String = ""
    var selectedFriendId: String = ""
    var selectedFriendName: String = ""
    var chats: [Chat] = []
    var msgs: [Message] = []
    var socket: Socket!
    var jwt: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjcsImlhdCI6MTU4MjY0ODMzNiwiZXhwIjoxNjE4NjQ0NzM2fQ.UYco7IDmL23ktkvq3K8pc8N0licAnGzxVGsU-CRgOxgxx"
    
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
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { sendMsg(); return true } // By "Enter" press...
    @IBAction func sendMsg(_ sender: Any) { sendMsg() } // By send button press...
    
    func sendMsg() {
        let msg = sendMessageTextField.text
        
        if (msg != "") {
            // Current time
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            
            msgs.append(Message(userId: self.userId, msg: msg ?? "", time: "\(hour):\(minutes)"))
            
            var toSocketId: String = ""
            for chat in self.chats {
                if chat.userId == self.selectedFriendId {
                    toSocketId = chat.socketId
                    break
                }
            }
            self.socket.socket.emit("add-message", [
                "message": msg,
                "fromUserId": self.userId,
                "toUserId": self.selectedFriendId,
                "toSocketId": toSocketId
            ])
            
            sendMessageTextField.text = ""
            updateMessages()
        }
    }

}
