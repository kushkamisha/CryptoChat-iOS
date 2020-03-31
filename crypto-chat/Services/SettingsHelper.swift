//
//  SettingsHelper.swift
//  crypto-chat
//
//  Created by Kushka Misha on 3/18/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

extension SettingsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
    /**
     Txs table start
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return txs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedTxIndex = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tx = txs[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "TxCell") as! TxCell
        cell.setTx(tx: tx)
        
        cell.backgroundColor = indexPath.row % 2 == 0 ? purple : UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.1)
        cell.selectionColor = white
        
        return cell
    }
    /**
     Txs table end
     */
    
    /**
     Keywords collection start
     */
    // Number of views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    
    // Populate views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "keyword", for: indexPath) as! KeywordCell
        cell.keywordLabel.text = keywords[indexPath.row]
        cell.keywordLabel.padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        return cell
    }
    /**
     Keywords collection end
     */
    
    func setupInputFields() {
        getUserProfile()
        
        self.txTableView.delegate = self
        self.txTableView.dataSource = self
        self.txTableView.backgroundColor = purple
        
        selectCorrectLang()
        loadUserBalance()
        
        headerDate.roundCorners(corners: [.topLeft], radius: 10)
        headerAmount.roundCorners(corners: [.topRight], radius: 10)
        avatar.cornerRadius = 60
        
        langSegmentedControl.setTitleTextAttributes([
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "SF Pro Text", size: 15) ?? UIFont.systemFont(ofSize: 15)
        ], for: .normal)
        langSegmentedControl.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .selected)
        
        keywordsCollectionView.backgroundColor = purple
        descriptionTitleView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        descriptionTextView.text = descriptionText
        descriptionTextView.textColor = translucentWhite
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == translucentWhite && descriptionTextView.text == descriptionText {
            descriptionTextView.text = nil
            descriptionTextView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextView.text.isEmpty {
            descriptionTextView.text = descriptionText
            descriptionTextView.textColor = translucentWhite
        }
    }
    
    func selectCorrectLang() {
        for i in 0..<languages.count {
            if languages[i][1] == currentLangCode {
                langSegmentedControl.selectedSegmentIndex = i
            }
        }
    }

    func getUserProfile() {
        AF.request("http://localhost:8080/auth/myProfile", parameters: ["token": jwt]
                ).responseJSON { response in
            switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let status = json["status"].stringValue
                    if (status == "success") {
                        // email, firstName, middleName, lastName, birthDate, description, avatar
                        let imageBase64String = json["avatar"].stringValue
                        let imageData = Data(base64Encoded: imageBase64String)
                        self.avatar.image = UIImage(data: imageData ?? Data())
                        self.fullName.text = "\(json["firstName"].stringValue) \(json["middleName"].stringValue) \(json["lastName"].stringValue)"
                        
                        let bdArr = json["birthDate"].stringValue.components(separatedBy: " ")
                        self.birthDate.text = "\(bdArr[2]) \(NSLocalizedString(self.months[Int(bdArr[1]) ?? 0], comment: "")) \(bdArr[0])"
                        
                        let desc = json["description"].stringValue
                        if desc != "" {
                            self.descriptionTextView.text = desc
                            self.descriptionTextView.textColor = UIColor.white
                        }
                    } else {
                        NSLog("Can't load user's profile because of an internal server error")
                    }
                case .failure(let error):
                    NSLog(error.localizedDescription)
            }
        }
    }
    
    func getUnpublishedTxs() {
        AF.request("http://localhost:8080/bc/transfers", parameters: ["token": jwt]
                ).responseJSON { response in
            switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let status = json["status"].stringValue
                    if (status == "success") {
                        let txs = json["txs"]
                        
                        self.txs = []
                        for (_, tx) in txs {
                            let arr = tx["createdAt"].stringValue.split(separator: " ")
                            let date = "\(arr[0]) \(NSLocalizedString(String(arr[1]), comment: "")) \(arr[2]) \(arr[3])"
                            self.txs.append(Tx(
                                id: tx["txId"].stringValue,
                                date: date,
                                userName: tx["fullName"].stringValue,
                                direction: tx["direction"].stringValue,
                                amount: tx["amount"].stringValue)
                            )
                        }
                        self.txTableView.reloadData()
                    } else {
                        NSLog("Can't load transactions because of an internal server error")
                    }
                case .failure(let error):
                    NSLog(error.localizedDescription)
            }
        }
    }
    
    func loadUserBalance() {
        AF.request("http://localhost:8080/bc/balanceInContract", parameters: ["token": jwt]).responseJSON { response in
            switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let status = json["status"].stringValue
                    if (status == "success") {
                        let balance = json["balanceInEth"]
                        self.userBalance.text = self.userBalance.text?.split(separator: " ").dropLast(2).joined(separator: " ")
                        self.userBalance.text! += " \(balance) ETH"
                    } else {
                        NSLog("Can't load user balance because of an internal server error")
                    }
                case .failure(let error):
                    NSLog(error.localizedDescription)
            }
        }
    }
    
    func publishTransaction(tx: Tx) {
        print("publishing tx")
        AF.request("http://localhost:8080/bc/publishTransfer",
                   method: .post,
                   parameters: [
                       "token": jwt,
                       "txId": tx.id
                   ],
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let hash = json["txHash"].stringValue
                    print("The tx is now mining and it's hash is \(hash)")
                    break
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
