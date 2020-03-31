//
//  SettingsViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 3/18/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var birthDate: UILabel!
    
    @IBOutlet weak var keywordsCollectionView: UICollectionView!
    @IBOutlet weak var descriptionTitleView: UIView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var langSegmentedControl: UISegmentedControl!
    @IBOutlet weak var txTableView: UITableView!
    @IBOutlet weak var userBalance: UILabel!
    
    @IBOutlet weak var headerDate: UILabel!
    @IBOutlet weak var headerAmount: UILabel!
    
    let descriptionText = NSLocalizedString("noDescription", comment: "")
    let keywords: [String] = ["consulting", "blockchain", "smart contracts", "teaching", "+"]
    let languages = [["Українська", "uk"], ["English", "en"]]
    let months = ["january", "february", "march", "april", "may", "june", "july", "august", "september", "october", "november", "december"]

    var currentLangCode: String = Locale.current.languageCode ?? ""
    var txs: [Tx] = []
    var selectedTxIndex: Int = -1
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(ChatViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = white
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        self.getUnpublishedTxs()
        refreshControl.endRefreshing()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeAction(swipe:)))
        rightSwipe.direction = UISwipeGestureRecognizer.Direction.right
        self.view.addGestureRecognizer(rightSwipe)

        setStatusBarBackgroundColor(color : purple)
        self.view.backgroundColor = purple
        
        listenForGlobalSocketMsgs()
        setupInputFields()
        getUnpublishedTxs()
    }
    
    @IBAction func changeLang(_ sender: Any) {
        if currentLangCode != languages[langSegmentedControl.selectedSegmentIndex][1] {
            print("The language was changed")
            
            // Alert to restart app to change the app language
            let alertController = UIAlertController(title: NSLocalizedString("langChange", comment: ""), message: NSLocalizedString("langChangeDescr", comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("yes", comment: ""), style: UIAlertAction.Style.default) {
                UIAlertAction in
                NSLog("OK Pressed")
                
                self.currentLangCode = self.languages[self.langSegmentedControl.selectedSegmentIndex][1]
                UserDefaults.standard.set([self.currentLangCode], forKey: "AppleLanguages")
                UserDefaults.standard.synchronize()
                
                exit(0)
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("restartLater", comment: ""), style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                self.selectCorrectLang()
                NSLog("Cancel Pressed")
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
        print(currentLangCode)
    }
    
    @IBAction func publishTx(_ sender: Any) {
        if (self.selectedTxIndex != -1) {
            let alertController = UIAlertController(title: NSLocalizedString("attention", comment: ""), message: NSLocalizedString("publishTx", comment: ""), preferredStyle: .alert)
            let okAction = UIAlertAction(title: NSLocalizedString("publish", comment: ""), style: UIAlertAction.Style.default) {
                UIAlertAction in
                // Publish tx
                self.publishTransaction(tx: self.txs[self.selectedTxIndex])
                print("OK Pressed")
            }
            let cancelAction = UIAlertAction(title: NSLocalizedString("cancel", comment: ""), style: UIAlertAction.Style.cancel) {
                UIAlertAction in
                print("Cancel Pressed")
            }
            alertController.addAction(okAction)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @objc func rightSwipeAction(swipe: UISwipeGestureRecognizer) {
        NSLog("right swipe action")
        
        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesScreen") as! ChatViewController
        self.present(vc, animated: true, completion: nil)
    }
}
