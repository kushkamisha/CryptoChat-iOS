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
    
    @IBOutlet weak var emailGlowingView: UIView!
    @IBOutlet weak var passGlowingView: UIView!
    @IBOutlet weak var repeatPassGlowingView: UIView!
    
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var uploadUserPhotoButton: UIButton!

    let imagePicker = UIImagePickerController()
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setStatusBarBackgroundColor(color : purple)
        self.view.backgroundColor = purple
        imagePicker.delegate = self
        setupInputFields()
    }
    
    @IBAction func showNextScreen(_ sender: Any) { if checkInputData() { registerUser() } }
    
    @IBAction func uploadUserPhoto(_ sender: Any) { chooseImageFromDevice() }

}
