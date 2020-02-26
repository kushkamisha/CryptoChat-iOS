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
    func getMessages(friendId: String) -> Future<[Dictionary<String, String>]> {
        return Future { completion in
            AF.request("http://localhost:8080/chat/messages",
                       parameters: [
                           "token": self.jwt,
                           "friendId": friendId
                       ]).responseJSON { response in
                switch response.result {
                    case .success(let data):
                        print(data)
                        
//                        completion(.success([String: String]))
                        break
                    case .failure(let error):
                        print(error.localizedDescription)
                }
            }
        }
    }
    
    func establishSocketConnection() {
        // Establish a socket connection
        self.socket = Socket.init(token: self.jwt)
        self.socket.connect()
    }
    
    func loadChats() {
        // Send request to load chats to the server
        AF.request("http://localhost:8080/chat/home",
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
}
