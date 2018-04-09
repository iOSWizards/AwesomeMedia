//
//  UIViewExtensions.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import UIKit

public enum AwesomeMediaViewDirection {
    case up
    case down
}

extension UIView {
    public func animateToggle(direction: AwesomeMediaViewDirection, completion: ((Bool)->Void)? = nil) {
        self.translatesAutoresizingMaskIntoConstraints = true
        
        let hideAnimation = {
            UIViewPropertyAnimator(duration: AwesomeMedia.autoHideControlViewAnimationTime, curve: .easeOut) {
                self.hiddenPosition(withDirection: direction)
                self.alpha = 0
            }
        }()
        hideAnimation.addCompletion { (_) in
            self.isHidden = true
            completion?(true)
        }
        
        let showAnimation = {
            UIViewPropertyAnimator(duration: AwesomeMedia.autoHideControlViewAnimationTime, curve: .linear) {
                self.isHidden = false
                self.alpha = 1
                self.visiblePosition(withDirection: direction)
            }
        }()
        showAnimation.addCompletion { (_) in
            completion?(false)
        }
        
        if isHidden {
            showAnimation.startAnimation()
        } else {
            hideAnimation.startAnimation()
        }
    }
    
    fileprivate func hiddenPosition(withDirection direction: AwesomeMediaViewDirection) {
        
        switch direction {
        case .up:
            self.frame.origin.y = -self.frame.size.height
        case .down:
            self.frame.origin.y = self.superview?.frame.size.height ?? UIScreen.main.bounds.size.height
        }
    }
    
    fileprivate func visiblePosition(withDirection direction: AwesomeMediaViewDirection) {
        
        switch direction {
        case .up:
            self.frame.origin.y = 0
        case .down:
            self.frame.origin.y = (self.superview?.frame.size.height ?? UIScreen.main.bounds.size.height) - self.frame.size.height
        }
    }
}
