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
    var userId : Int
    
    init(userId: Int) {
        self.userId = userId
        Socket.self.manager = SocketManager(socketURL: URL(string: "http://localhost:3000")!, config: [.log(true), .compress, .connectParams(["userId": 1])])
    }
    
    func connect() -> Future<Bool> {
        return Future { completion in
            self.socket = Socket.self.manager?.defaultSocket
                        
                    self.socket.on("connect") { ( dataArray, ack) -> Void in
                        print("connected to external server")
            //            self.requestUserChats()
                        completion(.success(true))
                    }
                    
                    self.socket.onAny { data in
                        print("\n\ndata")
                        print(data)
                    }
                
                    self.socket.connect()
        }
    }
    
//    func getUser(withID id: Int) -> Future<User> {
//      return Future { completion in
//        // Here you call an API
//        // that returns the user you are looking for.
//        APIClient.get(getUserURL(id: id)) { user in
//          completion(.success(user))
//        }
//      }
//    }
    
    func requestUserChats() -> Future<[Dictionary<String, String>]> {
        return Future { completion in
            print("\n\nEmitting a socket msg")
            self.socket.emit("chat-list", self.userId)
            
            self.socket.on("chat-list-response") { ( dataArray, ack) -> Void in
                let chatUsers = ((dataArray[0] as! NSDictionary)["chatList"] as! NSArray)
                var userList = [[String:String]]()
                for user in chatUsers {
                    let u = user as! NSDictionary
                    var tmp = [String:String]()

                    tmp["id"] = "\(u["id"] as! Int)"
                    tmp["online"] = u["online"] as? String
                    tmp["socketid"] = u["socketid"] as? String
                    tmp["username"] = u["username"] as? String
                    
                    userList.append(tmp)
                }

                completion(.success(userList))
            }
        }
    }

}
