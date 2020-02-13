//
//  MessageCell.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/12/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var msg: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
        msg.padding = UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15)
        msg.layer.masksToBounds = true
        msg.layer.cornerRadius = 10
    }
    
    func setMessage(message: Message) {
        msg.text = message.msg
        time.text = message.time
    }

}
