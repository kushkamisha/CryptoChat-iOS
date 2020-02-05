//
//  LoginViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/4/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit
import Alamofire

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
    
    @IBAction func signIn(_ sender: Any) {
        AF.request("http://localhost:8080/api/login").responseJSON { response in
            switch response.result {
                case .success(let data):
                    let dict = data as! NSDictionary
                    let status = dict["status"] as! String
                    if (status == "success") {
                        debugPrint("success")
                    } else {
                        let alert = UIAlertController(title: "Oops", message: "loginError", preferredStyle: .alert)
                        self.present(alert, animated: true)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

}
