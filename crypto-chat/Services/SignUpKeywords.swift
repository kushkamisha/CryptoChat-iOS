//
//  SignUpKeywords.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/27/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Foundation
import UIKit

extension SignUp2ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    // Number of views
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return keywords.count
    }
    
    // Populate views
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "keyword", for: indexPath) as! KeywordCell
        cell.keywordLabel.text = keywords[indexPath.row]
        cell.keywordLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        cell.keywordLabel.padding = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        
        return cell
    }
}
