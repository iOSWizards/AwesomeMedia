//
//  UIViewController+Alerts.swift
//  AwesomeLogin
//
//  Created by Evandro Harrison Hoffmann on 25/01/2017.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func showAlert(withTitle title: String? = nil, message: String?,  completion: (() -> ())? = nil, buttons: (UIAlertActionStyle, String, (() -> ())?)...) {
        
        guard let message = message, message.count > 0 else {
            return
        }
        
        if #available(iOS 8.0, *){
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            for button in buttons {
                alertController.addAction(UIAlertAction(title: button.1, style: button.0) { (_: UIAlertAction!) in
                    if let completion = completion { completion() }
                    if let actionBlock = button.2 { actionBlock() }
                })
            }
            self.present(alertController, animated: true, completion: nil)
        }else {
            // Handle prior iOS Versions
            
        }
    }
    
}
