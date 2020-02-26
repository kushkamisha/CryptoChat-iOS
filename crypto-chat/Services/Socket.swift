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
    
    var socket: SocketIOClient!
    static var manager: SocketManager?
    var token: String
    var isConnected: Bool = false
    
    init(token: String) {
        self.token = token
        Socket.self.manager = SocketManager(socketURL: URL(string: "http://localhost:8080")!, config: [.log(false), .compress, .connectParams(["token": token])])
    }
    
    func connect() {
        self.socket = Socket.self.manager?.defaultSocket
                        
        self.socket.on(clientEvent: .connect) { data, ack in
            print("connected to external server")
            self.isConnected = true
        }
    
        self.socket.on(clientEvent: .disconnect) { data, ack in
            self.isConnected = false
        }

        self.socket.connect()
    }
    
    func socketOn(event: String, callback success: @escaping (_ data: Any) -> Void) {
        self.socket.on(event) { (dataArr, ack) in
            print(dataArr) // don't remove. Otherwise messages will be added multiple times to the msgs list
            success(dataArr)
        }
    }

}
