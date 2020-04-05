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
        socket = Socket.init(token: jwt)
        socket.connect()
    }
    
    func listen4NewMessages() {
        listenForGlobalSocketMsgs()
        socket.socket.on("new-message") { data, ack in
            print("event new-message")
            let message = JSON(data)[0]
            print(message)
            if message["userId"].stringValue != userId && message["chatId"].stringValue == self.selectedChat.chatId {
                self.msgs.append(Message(
                    msgId: message["msgId"].stringValue,
                    userId: message["userId"].stringValue,
                    msg: message["message"].stringValue,
                    isRead: message["isRead"].boolValue,
                    time: message["createdAt"].stringValue
                ))
                
                if self.selectedChat.chatType == "paying" {
                    self.topBarEthereum.text = "\(message["amount"].stringValue) ETH"
                }

                self.pay4Msgs()
                self.updateMessages()
            }
        }
    }
    
    func listen4AmountChanges() {
        socket.socket.on("upd-amount") { data, ack in
            print("event upd-amount")
            let event = JSON(data)[0]
            
            if userId == event["toUserId"].stringValue &&
                self.selectedChat.fromUser == event["fromUserId"].stringValue &&
                self.selectedChat.chatType == "paying"
            {
                self.topBarEthereum.text = "\(event["amount"].stringValue) ETH"
            }
        }
    }
    
    func loadChats() {
        // Send request to load chats to the server
        AF.request("http://localhost:8080/chat/chatList",
                   parameters: ["token": jwt]).responseJSON { response in
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
                                if userId == chat["fromUser"].stringValue {
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
                        let imageBase64String = chat["avatar"].stringValue
                        let imageData = Data(base64Encoded: imageBase64String)
                        let avatar = UIImage(data: imageData ?? Data())
                        
                        let arr = chat["lastMsgTime"].stringValue.components(separatedBy: " ")
                        let timeLabel = arr.count == 2 ? "\(arr[0]) \(NSLocalizedString(arr[1], comment: ""))" : NSLocalizedString(arr[0], comment: "")
                        
                        self.chats.append(Chat(
                            chatId: chat["chatId"].stringValue,
                            socketId: "",
                            name: name,
                            chatType: chat["chatType"].stringValue,
                            fromUser: chat["fromUser"].stringValue,
                            avatar: avatar ?? #imageLiteral(resourceName: "user-default"),
                            lastMsgText: chat["lastMsgText"].stringValue,
                            lastMsgTime: timeLabel,
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
                       "token": jwt,
                       "chatId": self.selectedChat.chatId
                   ]).responseJSON { response in
            switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let msgs = json["messages"]
                    self.msgs = []
                    for (_, msg) in msgs {
                        self.msgs.append(Message(
                            msgId: msg["msgId"].stringValue,
                            userId: msg["userId"].stringValue,
                            msg: msg["text"].stringValue,
                            isRead: msg["isRead"].boolValue,
                            time: msg["time"].stringValue
                        ))
                    }
                    
                    let amount = json["amount"].stringValue
                    if (chat.chatType == "paying" && amount != "") {
                        self.topBarEthereum.text = "\(amount) ETH"
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
        if (chatType == "paying" && fromUserId == userId) {
            print("paying chat")

            var totalAmount = 0.0
            var lastMsgId = ""
            var lastUserId = ""
            for msg in self.msgs {
                if (msg.userId != userId && !msg.isRead) {
                    print("msg.msg: \(msg.msg)")
                    msg.isRead = true
                    totalAmount += Double(msg.msg.count) * self.CHARACTER_PRICE
                    lastMsgId = msg.msgId
                    lastUserId = msg.userId
                }
            }
            // pay for others messages
            sendMicrotx(toUser: lastUserId, amount: totalAmount, msgId: lastMsgId)
        } else {
            self.readMsgs()
        }
    }
    
    func readMsgs() {
        print("read messages")
        AF.request("http://localhost:8080/chat/readMessages",
                   method: .post,
                   parameters: ["token": jwt, "chatId": self.selectedChat.chatId],
                   encoder: JSONParameterEncoder.default).responseJSON { status in
            print(status)
        }
    }
    
    func sendMessage(message: String) {
        AF.request("http://localhost:8080/chat/message",
                   method: .post,
                   parameters: ["token": jwt, "chatId": self.selectedChat.chatId, "message": message],
                   encoder: JSONParameterEncoder.default).responseJSON { status in
            print(status)
            self.loadChats()
        }
    }
    
    func sendMicrotx(toUser: String, amount: Double, msgId: String) {
        print("sending microtx...")
        // Get private key from keychain
        guard let prKey: String = KeychainWrapper.standard.string(forKey: "prKey") else { return }
//        print(prKey)
        print("message id: \(msgId)")
        
        AF.request("http://localhost:8080/bc/signTransferByUserId",
                   method: .post,
                   parameters: [
                       "token": jwt,
                       "msgId": msgId,
                       "toUserId": toUser,
                       "amount": String(amount * 1000000000000000000),
                       "prKey": prKey
                   ],
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            switch response.result {
                case .success(let data):
                    print("the mtx is sent")
                    let json = JSON(data)
                    let rawTx = json["rawTx"].stringValue
                    let totalAmountWei = json["totalAmount"].intValue
                    let totalAmountEth: Double = Double(totalAmountWei) / 1000000000000000000.0
                    print("rawTx: \(rawTx)")
                    print("totalAmountEth: " + String(format: "%.5f", totalAmountEth))
                    self.topBarEthereum.text = String(format: "%.5f", totalAmountEth) + " ETH"
                    self.readMsgs()
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

//extension ChatViewController: UISearchBarDelegate, UISearchDisplayDelegate {
//
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        print("begin editing")
//    }
//    
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        print("end editing")
//    }
//    
//    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
//        print("cancel clicked")
//    }
//    
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        print("search clicked")
//    }
//}
