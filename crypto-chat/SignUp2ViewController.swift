//
//  SignUp2ViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/27/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Loaf
import UIKit
import SwiftKeychainWrapper

class SignUp2ViewController: UIViewController {
    
    @IBOutlet weak var keywordsCollectionView: UICollectionView!
    @IBOutlet weak var descriptionTitleView: UIView!
    @IBOutlet weak var ethereumAddrTitleView: UIView!
    @IBOutlet weak var copyEthAddrButton: UIButton!
    @IBOutlet weak var descriptionTextBox: UITextView!
    @IBOutlet weak var ethAddrTextField: UITextField!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var qrCodeView: UIView!
    
    let keywords: [String] = ["consulting", "blockchain", "smart contracts", "teaching", "+"]
    let descriptionText = NSLocalizedString("yourDescription", comment: "")
    
    var userId: String = ""
    var address: String = ""
    var token: String = ""
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setStatusBarBackgroundColor(color : purple)
        self.view.backgroundColor = purple
        
        print(userId)
        print(address)
        print(token)
        guard let prKey: String = KeychainWrapper.standard.string(forKey: "prKey") else { return }
        print(prKey)
        
        keywordsCollectionView.backgroundColor = purple
        
        qrCodeImage.image = generateQRCode(from: "eth:\(address)")
        setupInputFields()
    }
    
    @IBAction func copyEthAddr(_ sender: Any) {
        UIPasteboard.general.string = ethAddrTextField.text
        Loaf("Copied to the clipboard", state: .success, sender: self).show()
    }
    
    @IBAction func updateUserData(_ sender: Any) {
        finishUserSignUp()
    }
    
    
}
