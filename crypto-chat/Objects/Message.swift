//
//  Message.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/12/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Foundation

class Message {
    
    var msgId: String
    var userId: String
    var msg : String
    var isRead: Bool
    var time : String
    
    init(msgId: String, userId: String, msg: String, isRead: Bool, time: String) {
        self.msgId = msgId
        self.userId = userId
        self.msg = msg
        self.isRead = isRead
        self.time = time
    }
}
