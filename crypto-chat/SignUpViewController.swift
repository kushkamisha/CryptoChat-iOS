//
//  SignUpViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/27/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var emailLabel: UIView!
    @IBOutlet weak var firstNameLabel: UIView!
    @IBOutlet weak var middleNameLabel: UIView!
    @IBOutlet weak var lastNameLabel: UIView!
    @IBOutlet weak var passLabel: UIView!
    @IBOutlet weak var repeatPassLabel: UIView!
    @IBOutlet weak var birthDateLabel: UIView!
    
    @IBOutlet weak var emailInputField: UITextField!
    @IBOutlet weak var firstNameInputField: UITextField!
    @IBOutlet weak var middleNameInputField: UITextField!
    @IBOutlet weak var lastNameInputField: UITextField!
    @IBOutlet weak var passInputField: UITextField!
    @IBOutlet weak var repeatPassInputField: UITextField!
    @IBOutlet weak var birthDateInputField: UITextField!
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }
    
    func setupInputFields() {
        emailLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        firstNameLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        middleNameLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        lastNameLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        passLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        repeatPassLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        birthDateLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        
        let translucentWhite = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        emailInputField.attributedPlaceholder = NSAttributedString(string: "john@mail.com", attributes: [NSAttributedString.Key.foregroundColor: translucentWhite])
        firstNameInputField.attributedPlaceholder = NSAttributedString(string: "John", attributes: [NSAttributedString.Key.foregroundColor: translucentWhite])
        middleNameInputField.attributedPlaceholder = NSAttributedString(string: "James", attributes: [NSAttributedString.Key.foregroundColor: translucentWhite])
        lastNameInputField.attributedPlaceholder = NSAttributedString(string: "Doe", attributes: [NSAttributedString.Key.foregroundColor: translucentWhite])
        passInputField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: translucentWhite])
        repeatPassInputField.attributedPlaceholder = NSAttributedString(string: "password", attributes: [NSAttributedString.Key.foregroundColor: translucentWhite])
        birthDateInputField.attributedPlaceholder = NSAttributedString(string: "mm/dd/yyyy", attributes: [NSAttributedString.Key.foregroundColor: translucentWhite])
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let purple = UIColor.init(red: 122/255, green: 140/255, blue: 255/255, alpha: 1)
        setStatusBarBackgroundColor(color : purple)
        self.view.backgroundColor = purple
        
        setupInputFields()
    }
    
    @IBAction func showNextScreen(_ sender: Any) { navigateToScreen(screenName: "SignUp2Screen") }
    
    @IBAction func uploadUserPhoto(_ sender: Any) {
        print("Upload a photo...")
    }
    

}
