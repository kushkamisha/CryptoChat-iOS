//
//  Message.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/11/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Foundation
import UIKit

class Chat {
    
    var userId: String
    var socketId: String
    var avatar: UIImage
    var chatType: UIImage
    var chatTypeSelected: UIImage
    var username: String
//    var message: String
//    var msgTime: String
    
    init (userId: String, socketId: String, avatar: UIImage, chatType: UIImage, chatTypeSelected: UIImage, username: String) {
        self.userId = userId
        self.socketId = socketId
        self.avatar = avatar
        self.chatType = chatType
        self.chatTypeSelected = chatTypeSelected
        self.username = username
//        self.message = message
//        self.msgTime = msgTime
    }
}
