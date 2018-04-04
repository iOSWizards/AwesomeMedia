//
//  DesignableTextField.swift
//  MV UI Hacks
//
//  Created by Evandro Harrison Hoffmann on 26/07/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

@IBDesignable
open class DesignableTextField: UITextField {

    // MARK: - TextField
    
    @IBInspectable open var insetX: CGFloat = 0
    @IBInspectable open var insetY: CGFloat = 0
    
    // placeholder position
    open override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }
    
    // text position
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: insetX , dy: insetY)
    }
    
    @IBInspectable open var placeholderColor: UIColor = UIColor.white {
        didSet {
            if let placeholder = placeholder {
                attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedStringKey.foregroundColor: placeholderColor])
            }
        }
    }
    
    
}
