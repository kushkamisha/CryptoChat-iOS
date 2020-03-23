//
//  TxCell.swift
//  crypto-chat
//
//  Created by Kushka Misha on 3/23/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit

class TxCell: UITableViewCell {

    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var txDirectionImg: UIImageView!
    @IBOutlet weak var amount: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        if (selected) {
            date.textColor = black
            userName.textColor = black
            amount.textColor = black
        } else {
            date.textColor = white
            userName.textColor = white
            amount.textColor = white
        }
    }
    
    func setTx(tx: Tx) {
        date.text = tx.date
        userName.text = tx.userName
//        txDirectionImg
        amount.text = tx.amount
    }

}
