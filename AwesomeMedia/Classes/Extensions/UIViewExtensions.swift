//
//  UIViewExtensions.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import UIKit
import MediaPlayer

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
            self.translatesAutoresizingMaskIntoConstraints = false
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
            self.translatesAutoresizingMaskIntoConstraints = false
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


// MARK: - Airplay

extension UIView {
    // show airplay
    public func showAirplayMenu() {
        let volumeView = MPVolumeView()
        self.addSubview(volumeView)
        // loop through different items in MPVolumeView
        for view in volumeView.subviews {
            if let button = view as? UIButton {
                // add action to airPlayButton
                button.sendActions(for: .touchUpInside)
                button.isHidden = true
            }
        }
    }
}

// MARK: - ViewController from view

extension UIView {
    public var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}
