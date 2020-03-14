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
import SwiftKeychainWrapper

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
                self.pay4Msgs()
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
    
    func getMessages(chat: Chat) {
        AF.request("http://localhost:8080/chat/messages",
                   parameters: [
                       "token": self.jwt,
                       "chatId": self.selectedChat.chatId
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
                    
                    self.pay4Msgs()
                    self.updateMessages()

                    break
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    func pay4Msgs() {
        let chatType = self.selectedChat.chatType
        let fromUserId = self.selectedChat.fromUser
        if (chatType == "paying" && fromUserId == self.userId) {
            print("paying...")
            for msg in self.msgs {
                if (msg.userId != self.userId && !msg.isRead) {
                    // pay for others messages
                    sendMicrotx(toUser: msg.userId, amount: Double(msg.msg.count) * self.CHARACTER_PRICE)
                }
            }
        }
    }
    
    func readMsgs() {
        AF.request("http://localhost:8080/chat/readMessages",
                   method: .post,
                   parameters: ["token": self.jwt, "chatId": self.selectedChat.chatId],
                   encoder: JSONParameterEncoder.default).responseJSON { status in
            print(status)
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
    
    func sendMicrotx(toUser: String, amount: Double) {
        print("sending microtx...")
        // Get private key from keychain
        guard let prKey: String = KeychainWrapper.standard.string(forKey: "prKey") else { return }
//        print(prKey)
        
        AF.request("http://localhost:8080/bc/signTransferByUserId",
                   method: .post,
                   parameters: [
                       "token": self.jwt,
                       "toUserId": toUser,
                       "amount": String(amount),
                       "prKey": prKey
                   ],
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let rawTx = json["rawTx"].stringValue
                    let totalAmountWei = json["totalAmount"].intValue
                    let totalAmountEth: Double = Double(totalAmountWei) / 1000000000000000000.0
                    print("rawTx: \(rawTx)")
                    print("totalAmountEth: " + String(format: "%.5f", totalAmountEth))
                    self.topBarEthereum.text = String(format: "%.5f", totalAmountEth) + " ETH"
                    break
                case .failure(let error):
                    print(error.localizedDescription)
            }
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
