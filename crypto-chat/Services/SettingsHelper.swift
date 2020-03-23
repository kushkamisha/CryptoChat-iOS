//
//  SettingsHelper.swift
//  crypto-chat
//
//  Created by Kushka Misha on 3/18/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit

extension SettingsViewController: UICollectionViewDataSource, UICollectionViewDelegate, UITextViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    /**
     Lang picker begin
     */
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1 // num of columns in lang picker
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return languages.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return languages[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        currentLang = languages[row]
        print(currentLang)
    }
    /**
     Lang picker end
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
    
    func setupInputFields() {
        self.langPicker.delegate = self
        self.langPicker.dataSource = self
        
        keywordsCollectionView.backgroundColor = purple
        descriptionTitleView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
        descriptionTextView.text = descriptionText
        descriptionTextView.textColor = translucentWhite
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descriptionTextView.textColor == translucentWhite {
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
}
