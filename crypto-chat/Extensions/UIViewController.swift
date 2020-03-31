//
//  UIViewController.swift
//  crypto-chat
//
//  Created by Kushka Misha on 2/6/20.
//  Copyright © 2020 Misha Kushka. All rights reserved.
//

import UIKit
import SwiftyJSON
import Loaf

extension UIViewController {
    
    func navigateToScreen(screenName: String, storyboardName: String = "Main") {
        // Navigate to the Messages screen
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: screenName)
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }

    func setStatusBarBackgroundColor(color: UIColor) {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = color
            statusbarView.tintColor = UIColor.white
            view.addSubview(statusbarView)
          
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
          
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = color
        }
    }
    
    func listenForGlobalSocketMsgs() {
        socket.socket.on("tx-confirmed") { data, ack in
            print("event tx-confirmed")
            let event = JSON(data)[0]
            
            print(event["userId"].stringValue)
            print(event["txHash"].stringValue)
            
            if event["userId"].stringValue == userId {
                Loaf(NSLocalizedString("txConfirmed", comment: ""), state: .success, location: .top, sender: self).show()
            }
        }
    }

}
