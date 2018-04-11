//
//  ShadowLayer.swift
//  AwesomeUIMagic
//
//  Created by Evandro Harrison Hoffmann on 2/9/18.
//

import UIKit

class ShadowLayer: UIView {
    
    fileprivate var shadowView: UIView?
    
    func setProperties(shadowColor: UIColor,
                              shadowOffset: CGSize,
                              shadowOpacity: Float,
                              shadowRadius: CGFloat) {
        
        backgroundColor = UIColor.clear
        layer.shadowColor = shadowColor.cgColor
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 50).cgPath
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
        layer.shouldRasterize = true
        layer.masksToBounds = true
        clipsToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateLayout()
    }
    
    func updateLayout() {
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
    
    func addShadowLayer(shadowColor: UIColor = UIColor.black,
                               shadowOffset: CGSize = CGSize(width: 2, height: 2),
                               shadowOpacity: Float = 0.5,
                               shadowRadius: CGFloat = 4,
                               size: CGSize) {
        removeShadowLayer()
        
        let shadowLayer = ShadowLayer(frame: CGRect(origin: CGPoint(), size: size))
        shadowLayer.center = self.center
        shadowLayer.setProperties(shadowColor: shadowColor,
                                  shadowOffset: shadowOffset,
                                  shadowOpacity: shadowOpacity,
                                  shadowRadius: self.layer.cornerRadius > 0 ? self.layer.cornerRadius/2 : shadowRadius)
        
        superview?.addSubview(shadowLayer)
        superview?.bringSubview(toFront: self)
        
        shadowLayer.updateLayout()
    }
    
    func removeShadowLayer() {
        for subview in subviews {
            if let subview = subview as? ShadowLayer {
                subview.removeFromSuperview()
            }
        }
    }
}
