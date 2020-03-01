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
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarUsername: UILabel!
    @IBOutlet weak var topBarAvatar: UIImageView!
    @IBOutlet weak var topBarChatType: UIImageView!
    
    @IBOutlet weak var sendMessageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    
    var userId: String = ""
    var username: String = ""
    var selectedChatId: String = ""
    var chats: [Chat] = []
    var msgs: [Message] = []
    var socket: Socket!
    var jwt: String = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOjIsImlhdCI6MTU4MjcyMjY2NSwiZXhwIjoxNjE4NzE5MDY1fQ.lZojTFdi3Imvxj43YbzFioXE9sDnYzXvHYoLt1zXVU0"
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ChatViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.init(red: 122/255, green: 140/255, blue: 255/255, alpha: 1)
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
//        establishSocketConnection()
        loadChats()
        refreshControl.endRefreshing()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let purple = UIColor.init(red: 122/255, green: 140/255, blue: 255/255, alpha: 1)
        setStatusBarBackgroundColor(color : purple)

        searchUserBar.backgroundImage = UIImage()
        searchUserBar.searchBarStyle = UISearchBar.Style.prominent
        searchUserBar.searchTextField.backgroundColor = UIColor.white
        searchUserBar.placeholder = "Search for a user"

        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        msgsTableView.delegate = self
        msgsTableView.dataSource = self
        sendMessageTextField.delegate = self
        
        msgsTableView.rowHeight = UITableView.automaticDimension
        chatsTableView.rowHeight = 75
        
        sendMessageTextField.attributedPlaceholder = NSAttributedString(string: "Type your message here...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)])
        
        self.chatsTableView.addSubview(self.refreshControl)
        
        establishSocketConnection()
        listen2NewMessages()
        loadChats()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { sendMsg(); return true } // By "Enter" press...
    @IBAction func sendMsg(_ sender: Any) { sendMsg() } // By send button press...
    
    func sendMsg() {
        let msg = sendMessageTextField.text!
        
        if (msg != "") {
            sendMessage(chatId: self.selectedChatId, message: msg)

            // Current time
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            
            msgs.append(Message(userId: self.userId, msg: msg, time: "\(hour):\(minutes)"))
            
            sendMessageTextField.text = ""
            updateMessages()
        }
    }

}
