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

    var chatId: String
    var socketId: String
    var name: String
    var chatType: String
    var fromUser: String
    var avatar: UIImage
    var chatTypeImage: UIImage
    var chatTypeSelectedImage: UIImage
    
    init (chatId: String, socketId: String, name: String, chatType: String, fromUser: String, avatar: UIImage, chatTypeImage: UIImage, chatTypeSelectedImage: UIImage) {
        self.chatId = chatId
        self.socketId = socketId
        self.name = name
        self.chatType = chatType
        self.fromUser = fromUser
        self.avatar = avatar
        self.chatTypeImage = chatTypeImage
        self.chatTypeSelectedImage = chatTypeSelectedImage
    }
}
