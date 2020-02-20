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
        self.socket = Socket.self.manager?.defaultSocket
        
        self.socket.on("connect") { ( dataArray, ack) -> Void in
            print("connected to external server")
            self._requestUserChats()
        }
        
        self.socket.onAny { data in
            print("\n\ndata")
            print(data)
        }
    
        self.socket.connect()
    }
    
    func _requestUserChats() {
        print("\n\nEmitting a socket msg")
        self.socket.emit("chat-list", self.userId)
    }

}
