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
    @IBOutlet weak var publishButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTx(tx: Tx) {
        date.text = tx.date
        userName.text = tx.userName
//        txDirectionImg
        amount.text = tx.amount
//        publishButton
    }

}
