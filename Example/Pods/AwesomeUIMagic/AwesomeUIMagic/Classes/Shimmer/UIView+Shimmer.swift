//
//  UIView+Shimmer.swift
//  AwesomeUIMagic
//
//  Created by Evandro Harrison Hoffmann on 2/9/18.
//

import UIKit

@IBDesignable
extension UIView {
    
    // MARK: - Associations
    
    private static let startShimmeringOnLoadAssociation = ObjectAssociation<NSObject>()
    
    // MARK: - Inspectables
    
    @IBInspectable
    public var startShimmeringOnLoad: Bool {
        get {
            return UIView.startShimmeringOnLoadAssociation[self] as? Bool ?? false
        }
        set (startShimmeringOnLoad) {
            UIView.startShimmeringOnLoadAssociation[self] = startShimmeringOnLoad as NSObject
            
            if startShimmeringOnLoad {
                startShimmerAnimation()
            } else {
                stopShimmerAnimation()
            }
        }
    }
}
