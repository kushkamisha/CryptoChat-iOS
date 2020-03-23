//
//  Tx.swift
//  crypto-chat
//
//  Created by Kushka Misha on 3/23/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

class Tx {
    
    var date: String = ""
    var userName: String = ""
    var direction: String = ""
    var amount: String = ""
    
    init(date: String, userName: String, direction: String, amount: String) {
        self.date = date
        self.userName = userName
        self.direction = direction
        self.amount = amount
    }
}
