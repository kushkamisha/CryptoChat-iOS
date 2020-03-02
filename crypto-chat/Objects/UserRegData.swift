//
//  userRegData.swift
//  crypto-chat
//
//  Created by Kushka Misha on 3/2/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit

class UserData {
    
    var email: String
    var pass: String
    var firstName: String
    var middleName: String
    var lastName: String
    var birthDate: String
    var photo: UIImage
    
    init(
        email: String,
        pass: String,
        firstName: String = "",
        middleName: String = "",
        lastName: String = "",
        birthDate: String = "",
        photo: UIImage = UIImage()
    ) {
        self.email = email
        self.pass = pass
        self.firstName = firstName
        self.middleName = middleName
        self.lastName = lastName
        self.birthDate = birthDate
        self.photo = photo
    }
}
