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
    @IBOutlet weak var lastMsgTime: UILabel!
    @IBOutlet weak var lastMsgText: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.cornerRadius = 25
        lastMsgTime.text = NSLocalizedString("wasActiveAt", comment: "")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if (selected) {
            usernameLabel.textColor = UIColor.white
            lastMsgText.textColor = UIColor.white
            lastMsgTime.textColor = UIColor.white
            chatTypeImageView.isHidden = true
            chatTypeSelected.isHidden = false
        } else {
            usernameLabel.textColor = UIColor.black
            lastMsgText.textColor = UIColor.black
            lastMsgTime.textColor = UIColor.black
            chatTypeImageView.isHidden = false
            chatTypeSelected.isHidden = true
        }
    }
    
    func setChat(chat: Chat) {
        avatarImageView.image = chat.avatar
        chatTypeImageView.image = chat.chatTypeImage
        chatTypeSelected.image = chat.chatTypeSelectedImage
        usernameLabel.text = chat.name
        lastMsgText.text = chat.lastMsgText
        lastMsgTime.text = chat.lastMsgTime
    }

}
