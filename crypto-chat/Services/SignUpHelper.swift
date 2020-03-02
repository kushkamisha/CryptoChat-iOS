//
//  SignUpKeywords.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/27/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Foundation
import UIKit

extension SignUp2ViewController: UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate {
    
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
    
    func setupInputFields() {
        descriptionTitleView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        ethereumAddrTitleView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        copyEthAddrButton.roundCorners(corners: [.bottomRight], radius: 10)
        descriptionTextBox.text = descriptionText
        descriptionTextBox.textColor = translucentWhite
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextBox.textColor == translucentWhite {
            descriptionTextBox.text = nil
            descriptionTextBox.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if descriptionTextBox.text.isEmpty {
            descriptionTextBox.text = descriptionText
            descriptionTextBox.textColor = translucentWhite
        }
    }
}
