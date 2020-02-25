//
//  Services.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/20/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Foundation
import SocketIO

class Socket {
    
    var socket : SocketIOClient!
    static var manager : SocketManager?
    var token : String
    
    init(token: String) {
        self.token = token
        Socket.self.manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(false), .compress, .connectParams(["token": token])])
    }
    
    func connect() -> Future<Bool> {
        return Future { completion in
            self.socket = Socket.self.manager?.defaultSocket
                        
                    self.socket.on("connect") { ( dataArray, ack) -> Void in
                        print("connected to external server")
                        completion(.success(true))
                    }
                    
//                    self.socket.onAny { data in
//                        print("\n\ndata")
//                        print(data)
//                    }

                    self.socket.connect()
        }
    }
    
    func requestUserChats() -> Future<[Dictionary<String, String>]> {
        return Future { completion in
//            print("\n\nEmitting a socket msg")
//            self.socket.emit("chat-list", self.token)
            
            self.socket.on("chat-list-response") { ( dataArray, ack) -> Void in
                let chatUsers = (dataArray[0] as! NSDictionary)["chatList"] as! NSArray
                var userList = [[String: String]]()
                for user in chatUsers {
                    let u = user as! NSDictionary
                    var tmp = [String: String]()

                    tmp["id"] = "\(u["id"] as! Int)"
                    tmp["online"] = u["online"] as? String
                    tmp["socketId"] = u["socketid"] as? String
                    tmp["username"] = u["username"] as? String
                    
                    userList.append(tmp)
                }

                completion(.success(userList))
            }
        }
    }
    
    func socketOn(event: String, callback success: @escaping (_ data: Any) -> Void) {
        self.socket.on(event) { (dataArr, ack) in
            print(dataArr) // don't remove. Otherwise messages will be added multiple times to the msgs list
            success(dataArr)
        }
    }

}
