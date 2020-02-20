//
//  Message.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/12/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Foundation

class Message {
    
    var userId: String
    var msg : String
    var time : String
    
    init(userId: String, msg: String, time: String) {
        self.userId = userId
        self.msg = msg
        self.time = time
    }
}
