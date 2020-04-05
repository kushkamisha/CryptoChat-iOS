//
//  ChatViewController.ext.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/24/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit

extension ChatViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == msgsTableView ? msgs.count : chats.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == chatsTableView) {
            let chat = chats[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
            cell.setChat(chat: chat)
            
            cell.selectionColor = purple
            
            return cell
        }
        
        let msg = msgs[indexPath.row]
        if (msg.userId == userId) {
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
            self.isChatSelected(status: true)
            self.selectedChat = chats[indexPath.row]
            
            if (self.selectedChat.chatType != "paying") {
                self.topBarEthereum.isHidden = true
            } else {
                self.topBarEthereum.isHidden = false
            }

            getMessages(chat: chats[indexPath.row])
            
            topBarUsername.text = chats[indexPath.row].name
            topBarAvatar.image = chats[indexPath.row].avatar
            topBarChatType.image = chats[indexPath.row].chatTypeSelectedImage
        }
    }
    
    func updateMessages() {
        self.msgsTableView.reloadData()
        if self.msgs.count > 0 {
            self.msgsTableView.scrollToRow(at: IndexPath(item:self.msgs.count-1, section: 0), at: .bottom, animated: false)
        }
    }
    
}

extension ChatViewController: UISearchBarDelegate {

    func searchBarSetup() {
        let searchBar = UISearchBar(frame: CGRect(x: 0, y: 0, width: 100, height: 70))
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["Name", "Year", "By"]
        
        searchBar.delegate = self
        
        chatsTableView.tableHeaderView = searchBar
    }
    
    // MARK: - search bar delegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(index: searchBar.selectedScopeButtonIndex, text: searchText)
    }
    
    func filter(index: Int, text: String) {
        print("Filtering index: \(index)")
        
        chats = chats.filter({ (chat: Chat) -> Bool in
            return chat.name.contains(text)
        })
        chatsTableView.reloadData()
    }
    
}
