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
        if (tableView == msgsTableView) {
            return msgs.count
        } else {
            if isFiltering { return filteredChats.count }
            return chats.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (tableView == chatsTableView) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell") as! ChatCell
            let chat: Chat
            if isFiltering {
                chat = filteredChats[indexPath.row]
            } else {
                chat = chats[indexPath.row]
            }
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
            self.selectedChat = isFiltering ? filteredChats[indexPath.row] : chats[indexPath.row]
            
            print(self.selectedChat.name)
            print(self.selectedChat.chatId)
            
            self.topBarEthereum.isHidden = self.selectedChat.chatType != "paying" ? true : false

            getMessages()
            
            topBarUsername.text = self.selectedChat.name
            topBarAvatar.image = self.selectedChat.avatar
            topBarChatType.image = self.selectedChat.chatTypeSelectedImage
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

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filter(searchText, category: searchBar.selectedScopeButtonIndex)
    }
    
    func filter(_ searchText: String, category: Int = 0) {
        filteredChats = chats.filter({ (chat: Chat) -> Bool in
            return chat.name.lowercased().contains(searchText.lowercased())
        })
        chatsTableView.reloadData()
    }
}
