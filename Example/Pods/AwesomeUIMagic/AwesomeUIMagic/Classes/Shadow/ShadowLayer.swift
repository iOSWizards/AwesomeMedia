//
//  ShadowLayer.swift
//  AwesomeUIMagic
//
//  Created by Evandro Harrison Hoffmann on 2/9/18.
//

import UIKit

public class ShadowLayer: UIView {
    
    fileprivate var shadowView: UIView?
    
    public func setProperties(shadowColor: UIColor,
                              shadowOffset: CGSize,
                              shadowOpacity: Float,
                              shadowRadius: CGFloat) {
        
        backgroundColor = UIColor.clear
        layer.shadowColor = shadowColor.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shouldRasterize = true
        layer.masksToBounds = true
        clipsToBounds = false
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        
        updateLayout()
    }
    
    public func updateLayout() {
        guard let superview = superview else {
            return
        }
        
        guard let shadowView = shadowView else {
            return
        }
        
        guard shadowView.constraints.count > 0 else {
            return
        }
        
        superview.removeConstraints(constraints)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .centerX, relatedBy: .equal, toItem: shadowView, attribute: .centerX, multiplier: 1, constant: 0))
        
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .centerY, relatedBy: .equal, toItem: shadowView, attribute: .centerY, multiplier: 1, constant: 0))
        
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .width, relatedBy: .equal, toItem: shadowView, attribute: .width, multiplier: 1, constant: 0))
        
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: shadowView, attribute: .height, multiplier: 1, constant: 0))
    }
}

extension UIView {
    
    public func addShadowLayer(shadowColor: UIColor = UIColor.black,
                               shadowOffset: CGSize = CGSize(width: 2, height: 2),
                               shadowOpacity: Float = 0.5,
                               shadowRadius: CGFloat = 4) {
        removeShadowLayer()
        
        let shadowLayer = ShadowLayer(frame: self.frame)
        shadowLayer.setProperties(shadowColor: shadowColor,
                                  shadowOffset: shadowOffset,
                                  shadowOpacity: shadowOpacity,
                                  shadowRadius: self.layer.cornerRadius > 0 ? self.layer.cornerRadius/2 : shadowRadius)
        
        superview?.addSubview(shadowLayer)
        superview?.bringSubview(toFront: self)
        
        // add constraints
        superview?.addConstraint(NSLayoutConstraint(item: shadowLayer, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
        superview?.addConstraint(NSLayoutConstraint(item: shadowLayer, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
        superview?.addConstraint(NSLayoutConstraint(item: shadowLayer, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1, constant: 0))
        superview?.addConstraint(NSLayoutConstraint(item: shadowLayer, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1, constant: 0))
        
        shadowLayer.updateLayout()
    }
    
    public func removeShadowLayer() {
        for subview in superview?.subviews ?? [] {
            if let subview = subview as? ShadowLayer {
                subview.removeFromSuperview()
            }
        }
    }
}
