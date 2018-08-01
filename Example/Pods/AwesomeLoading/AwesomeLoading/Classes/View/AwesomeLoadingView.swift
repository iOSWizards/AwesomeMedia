//
//  LoadingView.swift
//  Micro Learning App
//
//  Created by Evandro Harrison Hoffmann on 10/08/2016.
//  Copyright © 2016 Mindvalley. All rights reserved.
//

import UIKit
import Lottie

class AwesomeLoadingView: UIView {
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var iconImageView: UIImageView!
    
    fileprivate var animating = false
    fileprivate var maxScale: CGFloat = 1.0
    fileprivate var pulseTimer: Timer?
    fileprivate var animationView: LOTAnimationView?
    
    static func newInstance() -> AwesomeLoadingView {
        return Bundle(for: self).loadNibNamed("AwesomeLoadingView", owner: self, options: nil)![0] as! AwesomeLoadingView
    }
    
    override func awakeFromNib() {
        self.isHidden = true
    }
}

// MARK: - Animations

extension AwesomeLoadingView {
    
    func show() {
        animating = true
        
        if self.frame.size.width < self.iconImageView.frame.size.width*1.2 {
            maxScale = self.frame.size.width/(self.iconImageView.frame.size.width*1.2)
        }
        
        self.isHidden = false
        self.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 1
        }, completion: { (_) in
            
        })
        
        self.alpha = 0
        UIView.animate(withDuration: 0.4, delay: 0.1, options: .curveEaseOut, animations: {
            self.alpha = 1
        })
        
        //pulse()
        //pulseTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(MVLoadingView.pulse), userInfo: nil, repeats: true)
        
        animationView = LOTAnimationView(json: loadingWingsJson)
        if let animationView = self.animationView {
            animationView.loopAnimation = true
            animationView.animationSpeed = 1
            //animationView.frame = CGRect(x: (self.frame.size.width/2)-240, y: (self.frame.size.height/2)-135, width: 480, height: 270)
            let scale: CGFloat = 1.5
            self.addSubview(animationView)
            //animationView.addShadowLayer(size: CGSize(width: 90, height: 90))
            
            animationView.translatesAutoresizingMaskIntoConstraints = false
            
            addConstraint(NSLayoutConstraint(item: animationView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 480*scale))
            addConstraint(NSLayoutConstraint(item: animationView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 270*scale))
            addConstraint(NSLayoutConstraint(item: animationView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
            addConstraint(NSLayoutConstraint(item: animationView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
            
            animationView.play(completion: { (finished) in
                print("did complete \(finished)")
            })
        }
    }
    
    func pulse() {
        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseIn, animations: {
            self.iconImageView.transform = CGAffineTransform(scaleX: self.maxScale*1.1, y: self.maxScale*1.1)
            self.iconImageView.alpha = 0.8
        }) { (_) in
            UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: {
                self.iconImageView.transform = CGAffineTransform(scaleX: self.maxScale*1, y: self.maxScale*1)
                self.iconImageView.alpha = 1
            })
        }
    }
    
    func hide() {
        animating = false
        animationView?.stop()
        
        pulseTimer?.invalidate()
        pulseTimer = nil
        
        UIView.animate(withDuration: 0.1, animations: {
            self.animationView?.transform = CGAffineTransform(scaleX: self.maxScale*0.9, y: self.maxScale*0.9)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.3, animations: {
                self.animationView?.transform = CGAffineTransform(scaleX: self.maxScale*2, y: self.maxScale*2)
                self.alpha = 0
            }, completion: { (_) in
                self.removeFromSuperview()
            })
        })
    }
}

extension UIView {
    
    public func startLoadingAnimationDelayed(_ delay: Double) {
        let delayTime = DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        DispatchQueue.main.asyncAfter(deadline: delayTime) {
            self.startLoadingAnimation()
        }
    }
    
    public func startLoadingAnimation() {
        stopLoadingAnimation()
        
        DispatchQueue.main.async {
            let loadingView = AwesomeLoadingView.newInstance()
            loadingView.frame = self.bounds
            self.addSubview(loadingView)
            
            loadingView.constraintToSuperview()

            loadingView.show()
        }
    }
    
    public func stopLoadingAnimation() {
        DispatchQueue.main.async {
            for subview in self.subviews {
                if let subview = subview as? AwesomeLoadingView {
                    subview.hide()
                }
            }
        }
    }
    
    public func constraintToSuperview() {
        guard let superview = superview else {
            return
        }
        translatesAutoresizingMaskIntoConstraints = false
        
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: superview, attribute: .leading, multiplier: 1, constant: 0))
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: superview, attribute: .trailing, multiplier: 1, constant: 0))
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: superview, attribute: .top, multiplier: 1, constant: 0))
        superview.addConstraint(NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: superview, attribute: .bottom, multiplier: 1, constant: 0))
    }
}

