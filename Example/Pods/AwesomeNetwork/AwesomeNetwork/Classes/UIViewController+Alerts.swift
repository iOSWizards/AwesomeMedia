//
//  UIViewController+Alerts.swift
//  AwesomeNetwork
//
//  Created by Evandro Harrison Hoffmann on 2/15/18.
//

import UIKit

extension UIViewController {
    
    public func showAlert(withTitle title: String? = nil, message: String?, completion: (() -> Void)? = nil, buttons: (UIAlertActionStyle, String, (() -> Void)?)...) {
        
        guard let message = message, message.count > 0 else {
            return
        }
        
        if #available(iOS 8.0, *) {
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            
            for button in buttons {
                alertController.addAction(UIAlertAction(title: button.1, style: button.0) { (_: UIAlertAction!) in
                    if let completion = completion { completion() }
                    if let actionBlock = button.2 { actionBlock() }
                })
            }
            self.present(alertController, animated: true, completion: nil)
        } else {
            // Handle prior iOS Versions
            
        }
    }
    
}
