//
//  http.ext.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/24/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Alamofire
import SwiftyJSON

extension ChatViewController {
    
    func establishSocketConnection() {
        // Establish a socket connection
        self.socket = Socket.init(token: self.jwt)
        self.socket.connect()
    }
    
    func listen2NewMessages() {
        self.socket.socket.on("new-message") { data, ack in
            print("event new-message")
            let message = JSON(data)[0]
            if message["userId"].stringValue != self.userId {
                self.msgs.append(Message(
                    userId: message["userId"].stringValue,
                    msg: message["message"].stringValue,
                    time: message["time"].stringValue
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
                        let name = "\(chat["firstName"].stringValue) \(chat["lastName"].stringValue)"
                        self.chats.append(Chat(
                            chatId: chat["chatId"].stringValue,
                            socketId: "",
                            name: name,
                            avatar: #imageLiteral(resourceName: "user-default"),
                            chatType: #imageLiteral(resourceName: "free"),
                            chatTypeSelected: #imageLiteral(resourceName: "free white")
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
            msgsTableView.isHidden = false
            noChatsSelectedView.isHidden = true
        } else {
            sendMessageView.isHidden = true
            topBarVideoCall.isHidden = true
            topBarAudioCall.isHidden = true
            msgsTableView.isHidden = true
            noChatsSelectedView.isHidden = false
        }
    }
}
