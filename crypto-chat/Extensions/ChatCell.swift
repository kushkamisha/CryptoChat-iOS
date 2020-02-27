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
    @IBOutlet weak var chatTypeSelected: UIImageView!

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
        if (selected) {
            usernameLabel.textColor = UIColor.white
            msgTimeLabel.textColor = UIColor.white
            userMsgLabel.textColor = UIColor.white
            chatTypeImageView.isHidden = true
            chatTypeSelected.isHidden = false
        } else {
            usernameLabel.textColor = UIColor.black
            msgTimeLabel.textColor = UIColor.black
            userMsgLabel.textColor = UIColor.black
            chatTypeImageView.isHidden = false
            chatTypeSelected.isHidden = true
        }
    }
    
    func setChat(chat: Chat) {
        avatarImageView.image = chat.avatar
        chatTypeImageView.image = chat.chatType
        chatTypeSelected.image = chat.chatTypeSelected
        usernameLabel.text = chat.name
    }

}
