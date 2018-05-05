//
//  UIView+Shadow.swift
//  AwesomeUIMagic
//
//  Created by Evandro Harrison Hoffmann on 2/9/18.
//

import UIKit

@IBDesignable
extension UIView {
    
    // MARK: - Associations
    
    private static let addShadowAssociation = ObjectAssociation<NSObject>()
    
    // MARK: - Inspectables
    
    @IBInspectable
    public var addShadow: Bool {
        get {
            return UIView.addShadowAssociation[self] as? Bool ?? false
        }
        set (addShadow) {
            UIView.addShadowAssociation[self] = addShadow as NSObject
        }
    }

}
