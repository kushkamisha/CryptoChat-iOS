//
//  SignUpViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/27/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let purple = UIColor.init(red: 122/255, green: 140/255, blue: 255/255, alpha: 1)
        setStatusBarBackgroundColor(color : purple)
        self.view.backgroundColor = purple
    }

}
