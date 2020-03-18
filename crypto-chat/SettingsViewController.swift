//
//  SettingsViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 3/18/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var keywordsCollectionView: UICollectionView!
    @IBOutlet weak var descriptionTitleView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var chooseLangButton: UIButton!
    
    let descriptionText = NSLocalizedString("noDescription", comment: "")
    let keywords: [String] = ["consulting", "blockchain", "smart contracts", "teaching", "+"]
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setStatusBarBackgroundColor(color : purple)
        self.view.backgroundColor = purple
        setupInputFields()
    }
    
}
