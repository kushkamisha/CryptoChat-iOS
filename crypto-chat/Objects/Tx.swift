//
//  Tx.swift
//  crypto-chat
//
//  Created by Kushka Misha on 3/23/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

class Tx {
    
    var id: String = ""
    var date: String = ""
    var userName: String = ""
    var direction: String = ""
    var amount: String = ""
    
    init(id: String, date: String, userName: String, direction: String, amount: String) {
        self.id = id
        self.date = date
        self.userName = userName
        self.direction = direction
        self.amount = amount
    }
}
