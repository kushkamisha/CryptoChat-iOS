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
import Loaf

struct Login: Encodable {
    let email: String
    let pass: String
}

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailInputLabel: UIView!
    @IBOutlet weak var passInputLabel: UIView!
    @IBOutlet weak var signInBigLabel: UILabel!
    @IBOutlet weak var emailInputField: UITextField!
    @IBOutlet weak var passInputField: UITextField!
    
    @IBAction func showSignUpScreen(_ sender: Any) { navigateToScreen(screenName: "SignUpScreen")}
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        emailInputLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        passInputLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        signInBigLabel.transform = CGAffineTransform(rotationAngle: -CGFloat.pi / 2)
        emailInputField.attributedPlaceholder = NSAttributedString(string: "email@example.com", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)])
        passInputField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)])
//        emailInputField.text = "bob"
//        passInputField.text = "bob"
        
        passInputField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("enter is pressed")
        signIn()
        return true
    } // By "Enter" press...
    
    @IBAction func signIn(_ sender: Any) { self.signIn() }
    
    func signIn() {
        guard let data = passInputField.text?.data(using: .utf8) else { return }
        let passHash = SHA512.hash(data: data).hexStr
        debugPrint(passHash)
        let login = Login(email: emailInputField.text ?? "", pass: passHash)
        
        AF.request("http://localhost:8080/auth/login",
                   method: .post,
                   parameters: login,
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            switch response.result {
                case .success(let data):
                    let dict = data as! NSDictionary
                    let status = dict["status"] as! String
                    print(dict)
                    if (status == "success") {
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesScreen") as! ChatViewController
                        vc.modalPresentationStyle = .fullScreen
                        vc.jwt = dict["token"] as! String
                        vc.userId = "\(dict["userId"]!)"
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        Loaf(NSLocalizedString("loginError", comment: ""), state: .error, sender: self).show()
                    }
                case .failure(let error):
                    Loaf(NSLocalizedString("connectionError", comment: ""), state: .error, sender: self).show()
                    print(error.localizedDescription)
            }
        }
    }

}
