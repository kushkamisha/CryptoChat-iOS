//
//  LoginViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/4/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailInputLabel: UIView!
    @IBOutlet weak var passInputLabel: UIView!
    @IBOutlet weak var signInBigLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()

        emailInputLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        passInputLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        signInBigLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }

}
