//
//  ShadowView.swift
//  AwesomeUIMagic
//
//  Created by Evandro Harrison Hoffmann on 2/9/18.
//

import UIKit

public class ShadowView: UIView {
    
    // MARK: - Inspectables
    
    @IBInspectable public var shadowColor: UIColor = UIColor.clear
    
    @IBInspectable public var shadowOffset: CGSize = CGSize.zero
    
    @IBInspectable public var shadowOpacity: Float = 0
    
    @IBInspectable public var shadowRadius: CGFloat = 0
    
    // MARK: - Shadow Updates
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        if addShadow {
            addShadowLayer(shadowColor: shadowColor,
                           shadowOffset: shadowOffset,
                           shadowOpacity: shadowOpacity,
                           shadowRadius: shadowRadius)
        }
    }
    
}
