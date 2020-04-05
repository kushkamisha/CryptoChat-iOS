//
//  MessagesViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/5/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit
import SwiftKeychainWrapper


struct LoadChats: Encodable {
    let userId: Int
}

class ChatViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchUserBar: UISearchBar!
    @IBOutlet weak var chatsTableView: UITableView!
    @IBOutlet weak var msgsTableView: UITableView!
    @IBOutlet weak var noChatsSelectedLabel: UILabel!
    @IBOutlet weak var noChatsSelectedView: UIView!
    
    @IBOutlet weak var topBarView: UIView!
    @IBOutlet weak var topBarUsername: UILabel!
    @IBOutlet weak var topBarAvatar: UIImageView!
    @IBOutlet weak var topBarChatType: UIImageView!
    @IBOutlet weak var topBarVideoCall: UIImageView!
    @IBOutlet weak var topBarAudioCall: UIImageView!
    @IBOutlet weak var topBarEthereum: UILabel!
    
    @IBOutlet weak var sendMessageTextField: UITextField!
    @IBOutlet weak var sendMessageButton: UIButton!
    @IBOutlet weak var sendMessageView: UIView!
    
    var username: String = ""
    var selectedChat: Chat = Chat(chatId: "", socketId: "", name: "", chatType: "", fromUser: "", avatar: UIImage(), lastMsgText: "", lastMsgTime: "", chatTypeImage: UIImage(), chatTypeSelectedImage: UIImage())
    var chats: [Chat] = []
    var filteredChats: [Chat] = []
    var msgs: [Message] = []
    var chatSelected: Bool = false
    let CHARACTER_PRICE = 0.00001 // ETH = about $0.001
    
    var isSearchBarEmpty: Bool {
        return searchUserBar.text?.isEmpty ?? true
    }
    
    var isFiltering: Bool {
        return !isSearchBarEmpty
    }
    
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
    
    @IBAction func goToSettings(_ sender: Any) {
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SettingsScreen") as! SettingsViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarBackgroundColor(color : purple)
        topBarView.backgroundColor = purple
        topBarAvatar.cornerRadius = 25

        searchUserBar.backgroundImage = UIImage()
        searchUserBar.searchBarStyle = UISearchBar.Style.prominent
        searchUserBar.searchTextField.backgroundColor = UIColor.white
        searchUserBar.placeholder = NSLocalizedString("searchForAUser", comment: "")
        searchUserBar.delegate = self

        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        msgsTableView.delegate = self
        msgsTableView.dataSource = self
        sendMessageTextField.delegate = self
        
        noChatsSelectedLabel.text = NSLocalizedString("noChatsSelected", comment: "")
        noChatsSelectedLabel.backgroundColor = purple
        noChatsSelectedLabel.padding = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        noChatsSelectedLabel.layer.masksToBounds = true
        noChatsSelectedLabel.layer.cornerRadius = 10
        
        msgsTableView.rowHeight = UITableView.automaticDimension
        chatsTableView.rowHeight = 76
        
        sendMessageTextField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("typeYourMsgHere", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)])
        
        self.chatsTableView.addSubview(self.refreshControl)
        
        isChatSelected(status: false)
        establishSocketConnection()
        listen4NewMessages()
        listen4AmountChanges()
        loadChats()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { sendMsg(); return true } // By "Enter" press...
    @IBAction func sendMsg(_ sender: Any) { sendMsg() } // By send button press...
    
    func sendMsg() {
        let msg = sendMessageTextField.text!
        
        if (msg != "") {
            sendMessage(message: msg)

            // Current time
            let date = Date()
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            let minutes = calendar.component(.minute, from: date)
            
            msgs.append(Message(msgId: "", userId: userId, msg: msg, isRead: false, time: "\(hour):\(minutes)"))
            
            sendMessageTextField.text = ""
            updateMessages()
        }
    }

}
