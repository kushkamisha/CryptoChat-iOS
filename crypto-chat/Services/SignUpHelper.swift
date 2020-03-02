//
//  SignUpKeywords.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/27/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import Foundation
import UIKit

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {

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
