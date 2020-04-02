//
//  ProductInfoViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 4/2/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit

class ProductInfoViewController: UIViewController {
    
    @IBOutlet weak var githubUrl: UIButton!

    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func githubOpen(_ sender: Any) {
        if let url = URL(string: "https://www.github.com/kushkamisha") {
            UIApplication.shared.open(url)
        }
    }

}
