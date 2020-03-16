//
//  SignUpKeywords.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/27/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit
import CryptoKit
import Loaf
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper

extension SignUpViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {
    
    func setupInputFields() {
        emailLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        firstNameLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        middleNameLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        lastNameLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        passLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        repeatPassLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        birthDateLabel.roundCorners(corners: [.topLeft, .bottomLeft], radius: 10)
        
//        NSLocalizedString("", comment: "")
        
        let translucentWhite = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.5)
        emailInputField.attributedPlaceholder = NSAttributedString(string: "john@mail.com", attributes: [NSAttributedString.Key.foregroundColor: translucentWhite])
        firstNameInputField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("john", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: translucentWhite])
        middleNameInputField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("james", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: translucentWhite])
        lastNameInputField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("doe", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: translucentWhite])
        passInputField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("password", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: translucentWhite])
        repeatPassInputField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("password", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: translucentWhite])
        birthDateInputField.attributedPlaceholder = NSAttributedString(string: NSLocalizedString("mm/dd/yyyy", comment: ""), attributes: [NSAttributedString.Key.foregroundColor: translucentWhite])
        
        emailInputField.delegate = self
        passInputField.delegate = self
        repeatPassInputField.delegate = self
        emailInputField.addTarget(self, action: #selector(SignUpViewController.removeGlowing(_:)), for: .editingChanged)
        passInputField.addTarget(self, action: #selector(SignUpViewController.removeGlowing(_:)), for: .editingChanged)
        repeatPassInputField.addTarget(self, action: #selector(SignUpViewController.removeGlowing(_:)), for: .editingChanged)
        
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
    
    @objc func removeGlowing(_ textField: UITextField) {
        switch (textField) {
            case emailInputField:
                emailGlowingView.isHidden = true
                break
            case passInputField:
                passGlowingView.isHidden = true
                break
            case repeatPassInputField:
                repeatPassGlowingView.isHidden = true
                break
            default:
                break
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        removeGlowing(textField)
    }
    
    func invalidInputData(view: UIView) {
        view.roundCorners(corners: [.topRight, .bottomRight], radius: 10)
        view.addInnerShadow(onSide: UIView.innerShadowSide.all, shadowColor: UIColor.red, shadowSize: 8, shadowOpacity: 2)
    }
    
    func checkInputData() -> Bool {
        let email = emailInputField.text ?? ""
        let pass = passInputField.text ?? ""
        let repeatPass = repeatPassInputField.text ?? ""
        
        if (email == "") {
            emailGlowingView.isHidden = false
            Loaf(NSLocalizedString("emptyEmail", comment: ""), state: .error, sender: self).show()
            return false
        } else if (pass == "") {
            passGlowingView.isHidden = false
            Loaf(NSLocalizedString("emptyPass", comment: ""), state: .error, sender: self).show()
            return false
        } else if (repeatPass == "") {
            repeatPassGlowingView.isHidden = false
            Loaf(NSLocalizedString("emptyRepeatPass", comment: ""), state: .error, sender: self).show()
            return false
        } else if (pass != repeatPass) {
            repeatPassGlowingView.isHidden = false
            Loaf(NSLocalizedString("notSameRepeatPass", comment: ""), state: .error, sender: self).show()
            return false
        }
        
        emailGlowingView.isHidden = true
        passGlowingView.isHidden = true
        repeatPassGlowingView.isHidden = true
        
        let rangeEmail = NSRange(location: 0, length: email.utf16.count)
        let regexEmail = try! NSRegularExpression(pattern: "^\\w+@[a-zA-Z_]+?\\.[a-zA-Z]{2,3}$")
        let rangePass = NSRange(location: 0, length: pass.utf16.count)
        let regexPass = try! NSRegularExpression(pattern: "^(?=.*[a-z])(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\\$%\\^&\\*])(?=.{8,})")
        
        if regexEmail.matches(in: email, options: [], range: rangeEmail).count == 0 {
            Loaf(NSLocalizedString("incorrectEmailFormat", comment: ""), state: .error, sender: self).show()
            emailGlowingView.isHidden = false
            return false
        } else if regexPass.matches(in: pass, options: [], range: rangePass).count == 0 {
            passGlowingView.isHidden = false
            Loaf(NSLocalizedString("weakPass", comment: ""), state: .error, sender: self).show()
            return false
        }
        
        return true
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
    
    func registerUser() {
        guard let data = passInputField.text?.data(using: .utf8) else { return }
        let passHash = SHA512.hash(data: data).hexStr
        
        AF.request("http://localhost:8080/auth/register",
                   method: .post,
                   parameters: [
                        "email": emailInputField.text ?? "",
                        "pass": passHash,
                        "firstName": firstNameInputField.text ?? "",
                        "middleName": middleNameInputField.text ?? "",
                        "lastName": lastNameInputField.text ?? "",
                        "birthDate": birthDateInputField.text ?? ""
                   ],
                   encoder: JSONParameterEncoder.default).responseJSON { response in
            switch response.result {
                case .success(let data):
                    print("\nSuccessfully registered")
                    let json = JSON(data)
                    print(json)
                    let status = json["status"].stringValue
                    
                    if (status == "success") {
                        let vc = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "SignUp2Screen") as! SignUp2ViewController
                        vc.modalPresentationStyle = .fullScreen

                        vc.userId = json["userId"].stringValue
                        vc.address = json["address"].stringValue
                        vc.token = json["token"].stringValue
                        
                        // Save ethereum private key to keychain
                        let saveSuccessful: Bool = KeychainWrapper.standard.set(json["prKey"].stringValue, forKey: "prKey")
                        print("Saving prKey to keychain: \(saveSuccessful)")

                        self.present(vc, animated: true, completion: nil)
                    } else {
                        Loaf(NSLocalizedString("signupError", comment: ""), state: .error, sender: self).show()
                    }
                    
                    break
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
}
