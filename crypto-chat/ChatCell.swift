//
//  MessageCell.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/11/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit

class ChatCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var chatTypeImageView: UIImageView!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userMsgLabel: UILabel!
    @IBOutlet weak var msgTimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setChat(chat: Chat) {
        avatarImageView.image = chat.avatar
        chatTypeImageView.image = chat.chatType
        usernameLabel.text = chat.username
        userMsgLabel.text = chat.message
        msgTimeLabel.text = chat.msgTime
    }

}
