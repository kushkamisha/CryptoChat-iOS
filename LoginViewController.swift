//
//  LoginViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/4/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit
import CryptoKit
import Alamofire

struct Login: Encodable {
    let email: String
    let pass: String
}

class LoginViewController: UIViewController {

    @IBOutlet weak var emailInputLabel: UIView!
    @IBOutlet weak var passInputLabel: UIView!
    @IBOutlet weak var signInBigLabel: UILabel!
    @IBOutlet weak var emailInputField: UITextField!
    @IBOutlet weak var passInputField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailInputLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        passInputLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        signInBigLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
    }
    
    func navigateToScreen(screenName: String, storyboardName: String = "Main") {
        // Navigate to the Messages screen
               let storyBoard = UIStoryboard(name: "Main", bundle: nil)
               let newViewController = storyBoard.instantiateViewController(withIdentifier: screenName)
               newViewController.modalPresentationStyle = .fullScreen
               self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func signIn(_ sender: Any) {
        guard let data = passInputField.text?.data(using: .utf8) else { return }
        let passHash = SHA512.hash(data: data).hexStr
        debugPrint(passHash)
        let login = Login(email: emailInputField.text ?? "", pass: passHash)
        
        AF.request("http://localhost:8080/api/login",
                   method: .post,
                   parameters: login,
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            switch response.result {
                case .success(let data):
                    let dict = data as! NSDictionary
                    let status = dict["status"] as! String
                    if (status == "success") {
                        self.navigateToScreen(screenName: "NavigationScreen")
                    } else {
                        let alert = UIAlertController(title: NSLocalizedString("Oops", comment: ""), message: NSLocalizedString("loginError", comment: ""), preferredStyle: .alert)
                        self.present(alert, animated: true)
                        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                    }
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }

}
