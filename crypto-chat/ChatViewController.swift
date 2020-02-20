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
    
    var chats: [Chat] = []
    var msgs: [Message] = [
        Message(userId: 1, msg: "Hello", time: "13:50"),
        Message(userId: 2, msg: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nunc a tortor ac sapien suscipit vestibulum", time: "13:51"),
        Message(userId: 1, msg: "Whoa", time: "15:05")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarBackgroundColor(color : UIColor.init(red: 122/255, green: 140/255, blue: 255/255, alpha: 1))
        
        chatsTableView.delegate = self
        chatsTableView.dataSource = self
        msgsTableView.delegate = self
        msgsTableView.dataSource = self
        
        sendMessageTextField.delegate = self
        
        msgsTableView.rowHeight = UITableView.automaticDimension
        
//        chats = fillChats()
        chatsTableView.rowHeight = 75
        sendMessageTextField.attributedPlaceholder = NSAttributedString(string: "Type your message here...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)])
        
        loadChats()
    }
    
    func loadChats() {
        let params: [String: String] = [
            "userId": String(1),
        ]
        
        AF.request("http://localhost:3000/userSessionCheck",
                   method: .post,
                   parameters: params,
                   encoder: JSONParameterEncoder.default).responseJSON { response in
//            switch response.result {
                print(response)
                let socket = Socket.init(userId: 1)
//                case .success(let data):
//                    let dict = data as! NSDictionary
//                    let status = dict["status"] as! String
//                    if (status == "success") {
//                        self.navigateToScreen(screenName: "MessagesScreen")
//                    } else {
//                        let alert = UIAlertController(title: NSLocalizedString("Oops", comment: ""), message: NSLocalizedString("loginError", comment: ""), preferredStyle: .alert)
//                        self.present(alert, animated: true)
//                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//            }
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
        
        msgs.append(Message(userId: 1, msg: toSend ?? "", time: "\(hour):\(minutes)"))
        
        sendMessageTextField.text = ""
        
        msgsTableView.reloadData()
        
        return true
    }
    
    func fillChats() -> [Chat] {
        var tmpChats: [Chat] = []
        
        let chat1 = Chat(avatar: #imageLiteral(resourceName: "user-1"), chatType: #imageLiteral(resourceName: "unlocked"), chatTypeSelected: #imageLiteral(resourceName: "unlocked white"), username: "Ann Ketnye", message: "Do you know what does word \"thief\" mean?", msgTime: "just now")
        let chat2 = Chat(avatar: #imageLiteral(resourceName: "user-3"), chatType: #imageLiteral(resourceName: "free"), chatTypeSelected: #imageLiteral(resourceName: "free white"), username: "Bro Walker", message: "Hi, man. What's up?", msgTime: "5 minutes ago")
        let chat3 = Chat(avatar: #imageLiteral(resourceName: "user-2"), chatType: #imageLiteral(resourceName: "free"), chatTypeSelected: #imageLiteral(resourceName: "free white"), username: "Susanna", message: "You won't believe in what was just happened!!", msgTime: "3 hours ago")
        
        tmpChats.append(chat1)
        tmpChats.append(chat2)
        tmpChats.append(chat3)
        
        return tmpChats
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
        if (msg.userId == 1) {
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
            topBarUsername.text = chats[indexPath.row].username
            topBarAvatar.image = chats[indexPath.row].avatar
            topBarChatType.image = chats[indexPath.row].chatTypeSelected
        }
    }
    
}
