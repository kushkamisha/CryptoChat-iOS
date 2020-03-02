//
//  SignUp2ViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/27/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Loaf
import UIKit

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
    let translucentWhite = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
    let descriptionText = "Your description goes here..."
    let ethAddress = "0x635B4764D1939DfAcD3a8014726159abC277BecC"
    
    var userData: UserData = UserData(email: "", pass: "")
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
        //return UIStatusBarStyle.default   // Make dark again
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let purple = UIColor.init(red: 122/255, green: 140/255, blue: 255/255, alpha: 1)
        setStatusBarBackgroundColor(color : purple)
        self.view.backgroundColor = purple
        
        print(userData)
        
        keywordsCollectionView.backgroundColor = purple
        
        qrCodeImage.image = generateQRCode(from: "eth:\(ethAddress)")
        setupInputFields()
    }
    
    @IBAction func copyEthAddr(_ sender: Any) {
        UIPasteboard.general.string = ethAddrTextField.text
        Loaf("Copied to the clipboard", state: .success, sender: self).show()
    }
    
}
