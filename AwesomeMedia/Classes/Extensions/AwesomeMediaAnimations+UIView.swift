//
//  AwesomeMediaAnimations+UIView.swift
//  AwesomeMedia
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 29/06/17.
//

import UIKit

extension UIView{
    
    public func awesomeMediaAnimateFadeInLeftToRight(duration: Double = 0.35, alphaIn: CGFloat = 0, damping: CGFloat = 0.68, _ completion:(() -> Void)? = nil){
        self.alpha = alphaIn
        
        let center = CGRect(x: self.superview!.frame.origin.x, y: self.superview!.frame.size.height-self.frame.size.height, width: self.frame.width, height: self.frame.height)
        self.frame = CGRect(x: self.superview!.frame.origin.x-self.frame.width, y: self.superview!.frame.size.height-self.frame.size.height, width: self.frame.width, height: self.frame.height)
        
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: 0, options: .curveLinear, animations: {
            self.frame = center
            self.alpha = 1
        }, completion: { (didComplete) in
            //if didComplete {
            completion?()
            //}
        })
    }
    
    public func awesomeMediaAnimateTouchDown(duration: Double = 0.1, durationOut: Double = 0.2, scaleIn: CGFloat = 0.9, alphaIn: CGFloat = 0.9, autoAnimateUp: Bool = true, halfWay:(() -> Void)? = nil, _ completed:(() -> Void)? = nil){
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alphaIn
            self.transform = CGAffineTransform(scaleX: scaleIn, y: scaleIn)
        }, completion: { (didComplete) in
            //if didComplete {
            halfWay?()
            
            if autoAnimateUp{
                self.awesomeMediaAnimateTouchUp(duration: durationOut, {
                    completed?()
                })
            }
            //}
        })
    }
    
    public func awesomeMediaAnimateTouchUp(duration: Double = 0.2, _ completed:(() -> Void)? = nil){
        UIView .animate(withDuration: duration, animations: {
            self.alpha = 1
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }, completion: { (didComplete) in
            //if didComplete {
            completed?()
            //}
        })
    }
    
    public func awesomeMediaAnimateFadeOutRightToLeft(duration: Double = 0.3, _ completion:(() -> Void)? = nil){
        UIView.animate(withDuration: duration, animations: {
            if let superview = self.superview {
                self.frame = CGRect(x: superview.frame.origin.x-self.frame.width, y: superview.frame.size.height-self.frame.size.height, width: self.frame.width, height: self.frame.height)
            }
            self.alpha = 0
        }, completion: { (didComplete) in
            //if didComplete {
            completion?()
            //}
        })
    }
    
    public func awesomeMediaAnimateFadeOutLeftToRight(duration: Double = 0.3, _ completion:(() -> Void)? = nil){
        UIView.animate(withDuration: duration, animations: {
            if let superview = self.superview {
                self.frame = CGRect(x: superview.frame.size.width+self.frame.width, y: superview.frame.size.height-self.frame.size.height, width: self.frame.width, height: self.frame.height)
            }
            self.alpha = 0
        }, completion: { (didComplete) in
            //if didComplete {
            completion?()
            //}
        })
    }
}
