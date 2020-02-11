//
//  MessagesViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/5/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit

class ChatViewController: UIViewController {

    @IBOutlet weak var searchUserBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var chats: [Chat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarBackgroundColor(color : UIColor.init(red: 122/255, green: 140/255, blue: 255/255, alpha: 1))
        
        chats = fillChats()
        tableView.rowHeight = 75
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    
    func fillChats() -> [Chat] {
        var tmpChats: [Chat] = []
        
        let chat1 = Chat(avatar: #imageLiteral(resourceName: "user-1"), chatType: #imageLiteral(resourceName: "unlocked"), username: "Ann Ketnye", message: "Do you know what does word \"thief\" mean?", msgTime: "just now")
        let chat2 = Chat(avatar: #imageLiteral(resourceName: "user-3"), chatType: #imageLiteral(resourceName: "free"), username: "Bro Walker", message: "Hi, man. What's up?", msgTime: "5 minutes ago")
        let chat3 = Chat(avatar: #imageLiteral(resourceName: "user-2"), chatType: #imageLiteral(resourceName: "free"), username: "Susanna", message: "You won't believe in what was just happened!!", msgTime: "3 hours ago")
        
        tmpChats.append(chat1)
        tmpChats.append(chat2)
        tmpChats.append(chat3)
        
        return tmpChats
    }

}

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = chats[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
        cell.setChat(chat: chat)
        
        return cell
    }
    
}
