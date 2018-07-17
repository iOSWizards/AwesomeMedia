//
//  ShimmerView.swift
//  AwesomeLoading
//
//  Created by Emmanuel on 21/06/2018.
//

import UIKit

class ShimmerView: UIView, ShimmerEffect {
    override open static var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    open var gradientLayer: CAGradientLayer {
        return layer as! CAGradientLayer
    }
    
    open var animationDuration: TimeInterval = 3
    
    open var animationDelay: TimeInterval = 1.5
    
    open var gradientHighlightRatio: Double = 0.3
    
    @IBInspectable open var shimmerGradientTint: UIColor = .black
    
    @IBInspectable open var shimmerGradientHighlight: UIColor = .white
    
}

// MARK: - UIView Extension

extension UIView {
    
    public func startShimmerAnimation(delay: Double = 0.2,
                                      tint: UIColor = UIColor.init(red: 35/255.0, green: 39/255.0, blue: 47/255.0, alpha: 0.2),
                                      highlight: UIColor = UIColor.init(red: 40/255.0, green: 45/255.0, blue: 53/255.0, alpha: 0.8),
                                      highlightRatio: Double = 0.8,
                                      widthRatio: CGFloat = 1,
                                      heightRatio: CGFloat = 1,
                                      alignment: NSTextAlignment = .center) {
        stopShimmerAnimation()
        
        let shimmerView = ShimmerView()
        
        //shimmerView.frame = CGRect(x: 0, y: 0, width: self.bounds.width*widthRatio, height: self.bounds.height*heightRatio)
        //shimmerView.center = CGPoint(x: self.bounds.width/2, y: self.bounds.height/2)
        shimmerView.backgroundColor = .clear
        shimmerView.shimmerGradientTint = tint
        shimmerView.shimmerGradientHighlight = highlight
        shimmerView.animationDelay = delay
        shimmerView.gradientHighlightRatio = highlightRatio
        shimmerView.addShimmerAnimation()
        
        self.addSubview(shimmerView)
        
        shimmerView.translatesAutoresizingMaskIntoConstraints = false
        
        switch alignment {
        case .left:
            self.addConstraint(NSLayoutConstraint(item: shimmerView, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 0))
            break
        case .right:
            self.addConstraint(NSLayoutConstraint(item: shimmerView, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: 0))
            break
        default:
            self.addConstraint(NSLayoutConstraint(item: shimmerView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        }
        
        self.addConstraint(NSLayoutConstraint(item: shimmerView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        
        self.addConstraint(NSLayoutConstraint(item: shimmerView, attribute: .width, relatedBy: .equal, toItem: self, attribute: .width, multiplier: widthRatio, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: shimmerView, attribute: .height, relatedBy: .equal, toItem: self, attribute: .height, multiplier: heightRatio, constant: 0))
    }
    
    public func stopShimmerAnimation() {
        for subview in subviews {
            if let subview = subview as? ShimmerView {
                subview.removeShimmerAnimation()
                subview.removeFromSuperview()
            }
        }
    }
    
}
