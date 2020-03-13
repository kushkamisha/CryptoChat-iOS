//
//  http.ext.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/24/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Alamofire
import SwiftyJSON
import UIKit

extension ChatViewController {
    
    func establishSocketConnection() {
        // Establish a socket connection
        self.socket = Socket.init(token: self.jwt)
        self.socket.connect()
    }
    
    func listen4NewMessages() {
        self.socket.socket.on("new-message") { data, ack in
            print("event new-message")
            let message = JSON(data)[0]
            print(message)
            if message["userId"].stringValue != self.userId {
                self.msgs.append(Message(
                    userId: message["userId"].stringValue,
                    msg: message["message"].stringValue,
                    isRead: true,
                    time: message["createdAt"].stringValue
                ))
                self.updateMessages()
            }
        }
    }
    
    func loadChats() {
        // Send request to load chats to the server
        AF.request("http://localhost:8080/chat/chatList",
                   parameters: ["token": self.jwt]).responseJSON { response in
            switch response.result {
                case .success(let data):
                    let chats = JSON(data)["chats"]
                    self.chats = []
                    for (_, chat) in chats {
                        var chatTypeImage = UIImage()
                        var chatTypeSelectedImage = UIImage()
                        
                        switch(chat["chatType"].stringValue) {
                            case "free":
                                chatTypeImage = #imageLiteral(resourceName: "free")
                                chatTypeSelectedImage = #imageLiteral(resourceName: "free white")
                                break
                            case "locked":
                                chatTypeImage = #imageLiteral(resourceName: "locked-purple")
                                chatTypeSelectedImage = #imageLiteral(resourceName: "locked-white")
                                break
                            case "unlocked":
                                chatTypeImage = #imageLiteral(resourceName: "unlocked")
                                chatTypeSelectedImage = #imageLiteral(resourceName: "unlocked white")
                                break
                            case "paying":
                                if self.userId == chat["fromUser"].stringValue {
                                    chatTypeImage = #imageLiteral(resourceName: "ethereum-out-purple")
                                    chatTypeSelectedImage = #imageLiteral(resourceName: "ethereum-out-white")
                                } else {
                                    chatTypeImage = #imageLiteral(resourceName: "ethereum-in-purple")
                                    chatTypeSelectedImage = #imageLiteral(resourceName: "ethereum-in-white")
                                }
                                break
                            case "group":
                                break
                            default:
                                break
                        }
                        
                        let name = "\(chat["firstName"].stringValue) \(chat["lastName"].stringValue)"
                        self.chats.append(Chat(
                            chatId: chat["chatId"].stringValue,
                            socketId: "",
                            name: name,
                            chatType: chat["chatType"].stringValue,
                            fromUser: chat["fromUser"].stringValue,
                            avatar: #imageLiteral(resourceName: "user-default"),
                            chatTypeImage: chatTypeImage,
                            chatTypeSelectedImage: chatTypeSelectedImage
                        ))
                    }
                    self.chatsTableView.reloadData()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func getMessages(chatId: String) {
        AF.request("http://localhost:8080/chat/messages",
                   parameters: [
                       "token": self.jwt,
                       "chatId": chatId
                   ]).responseJSON { response in
            switch response.result {
                case .success(let data):
                    let msgs = JSON(data)["messages"]
                    self.msgs = []
                    for (_, msg) in msgs {
                        self.msgs.append(Message(
                            userId: msg["userId"].stringValue,
                            msg: msg["text"].stringValue,
                            isRead: msg["isRead"].boolValue,
                            time: msg["time"].stringValue
                        ))
                    }
                    self.updateMessages()
                    break
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func sendMessage(chatId: String, message: String) {
        AF.request("http://localhost:8080/chat/message",
                   method: .post,
                   parameters: ["token": self.jwt, "chatId": chatId, "message": message],
                   encoder: JSONParameterEncoder.default).responseJSON { status in
            print(status)
        }
    }
    
    func isChatSelected(status: Bool) {
        if (status) {
            sendMessageView.isHidden = false
            topBarVideoCall.isHidden = false
            topBarAudioCall.isHidden = false
            topBarEthereum.isHidden = false
            msgsTableView.isHidden = false
            noChatsSelectedView.isHidden = true
        } else {
            sendMessageView.isHidden = true
            topBarVideoCall.isHidden = true
            topBarAudioCall.isHidden = true
            topBarEthereum.isHidden = true
            msgsTableView.isHidden = true
            noChatsSelectedView.isHidden = false
        }
    }
}
