//
//  SignUp2Helper.swift
//  crypto-chat
//
//  Created by Kushka Misha on 3/3/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//


import UIKit
import Alamofire
import SwiftyJSON
import Loaf

/**
 Second SignUp screen
 */
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
        ethAddrTextField.text = address
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
        
        return UIImage(ciImage: scaledQrImage)
    }
    
    func finishUserSignUp() {
        AF.request("http://localhost:8080/auth/updateUserData",
                   method: .post,
                   parameters: [
                        "token": self.token,
                        "description": descriptionTextBox.text,
                        "keywords": "",
                   ],
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    let status = json["status"]
                    
                    if (status == "success") {
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "MessagesScreen") as! ChatViewController
                        vc.modalPresentationStyle = .fullScreen
                        vc.jwt = self.token
                        vc.userId = self.userId
                        self.present(vc, animated: true, completion: nil)
                    } else {
                        Loaf(NSLocalizedString("signup2Error", comment: ""), state: .error, sender: self).show()
                    }
                    
                    break
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
