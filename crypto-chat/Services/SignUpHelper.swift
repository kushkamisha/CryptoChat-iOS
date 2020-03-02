//
//  SignUpKeywords.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/27/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Foundation
import UIKit
import CryptoKit

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
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
        
        invalidInputData(view: emailGlowingView)
        invalidInputData(view: passGlowingView)
        invalidInputData(view: repeatPassGlowingView)
        emailGlowingView.isHidden = true
        passGlowingView.isHidden = true
        repeatPassGlowingView.isHidden = true
        
        userImage.layer.borderWidth = 5
        userImage.layer.masksToBounds = false
        userImage.layer.borderColor = UIColor.white.cgColor
        userImage.layer.cornerRadius = userImage.frame.height / 2
        userImage.clipsToBounds = true
    }
    
    func invalidInputData(view: UIView) {
        view.roundCorners(corners: [.topRight, .bottomRight], radius: 10)
        view.addInnerShadow(onSide: UIView.innerShadowSide.all, shadowColor: UIColor.red, shadowSize: 8, shadowOpacity: 2)
    }
    
    func checkInputData() {
        let email = emailInputField.text ?? ""
        let pass = passInputField.text ?? ""
        let repeatPass = repeatPassInputField.text ?? ""
        
        if (email == "") {
            invalidInputData(view: emailGlowingView)
        } else if (pass == "") {
            invalidInputData(view: passGlowingView)
        } else if (repeatPass == "") {
            invalidInputData(view: repeatPassGlowingView)
        } else {
            if (pass != repeatPass) {
                invalidInputData(view: repeatPassGlowingView)
            }
        }
        
        let range = NSRange(location: 0, length: email.utf16.count)
        let regexEmail = try! NSRegularExpression(pattern: "^\\w+@[a-zA-Z_]+?\\.[a-zA-Z]{2,3}$")
        let regexPass = try! NSRegularExpression(pattern: "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\\$%\\^&\\*])(?=.{8,})")
        
        if regexEmail.matches(in: email, options: [], range: range).count == 0 {
            print("invalid email")
        } else if regexPass.matches(in: email, options: [], range: range).count == 0 {
            print("invalid password")
        }
        
    }

    func chooseImageFromDevice() {
       imagePicker.allowsEditing = false
       imagePicker.sourceType = .photoLibrary
       
       present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            userImage.contentMode = .scaleAspectFill
            userImage.image = pickedImage
            uploadUserPhotoButton.isHidden = true
        }
       
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

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
        qrCodeView.roundCorners(corners: [.allCorners], radius: 10)
        ethAddrTextField.text = ethAddress
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
    
    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        
        guard let filter = CIFilter(name: "CIQRCodeGenerator") else { return nil }
        filter.setValue(data, forKey: "inputMessage")
        
        // Scale the image
        let transform = CGAffineTransform(scaleX: 10, y: 10)
        guard let scaledQrImage = filter.outputImage?.transformed(by: transform) else { return nil }
        
        // Invert the colors
//        guard let colorInvertFilter = CIFilter(name: "CIColorInvert") else { return nil }
//        colorInvertFilter.setValue(scaledQrImage, forKey: "inputImage")
//        guard let outputInvertedImage = colorInvertFilter.outputImage else { return nil }
        
        // Replace the black with transparency
//        guard let maskToAlphaFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
//        maskToAlphaFilter.setValue(scaledQrImage, forKey: "inputImage")
//        guard let outputCIImage = maskToAlphaFilter.outputImage else { return nil }
        
        return UIImage(ciImage: scaledQrImage)
    }
}
