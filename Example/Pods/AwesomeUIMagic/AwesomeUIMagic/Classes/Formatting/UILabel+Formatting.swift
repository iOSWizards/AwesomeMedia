//
//  DesignableLabel.swift
//  MV UI Hacks
//
//  Created by Evandro Harrison Hoffmann on 07/07/2016.
//  Copyright © 2016 It's Day Off. All rights reserved.
//

import UIKit

@IBDesignable
extension UILabel {
    
    // MARK: - Associations
    
    private static let lineHeightAssociation = ObjectAssociation<NSObject>()
    
    // MARK: - Inspectables
    
    @IBInspectable
    public var lineHeight: CGFloat {
        get {
            return UILabel.lineHeightAssociation[self] as? CGFloat ?? 0
        }
        set (lineHeight) {
            UILabel.lineHeightAssociation[self] = lineHeight as NSObject
            
            let attributedString = NSMutableAttributedString(string: self.text!)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = lineHeight - self.font.pointSize
            paragraphStyle.alignment = self.textAlignment
            attributedString.addAttribute(NSAttributedStringKey(rawValue: "NSParagraphStyleAttributeName"), value: paragraphStyle, range: NSMakeRange(0, self.text!.count))
            self.attributedText = attributedString
        }
    }
}
