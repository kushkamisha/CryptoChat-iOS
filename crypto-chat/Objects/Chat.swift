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
    var avatar: UIImage
    var chatType: UIImage
    var chatTypeSelected: UIImage
    
    init (chatId: String, socketId: String, name: String, avatar: UIImage, chatType: UIImage, chatTypeSelected: UIImage) {
        self.chatId = chatId
        self.socketId = socketId
        self.name = name
        self.avatar = avatar
        self.chatType = chatType
        self.chatTypeSelected = chatTypeSelected
    }
}
