//
//  DismissAnimator.swift
//  InteractiveModal
//
//  Created by Robert Chen on 1/8/16.
//  Copyright © 2016 Thorn Technologies. All rights reserved.
//

import UIKit
import AwesomeUIMagic

class AwesomeMediaDismissAnimator : NSObject {
}

extension AwesomeMediaDismissAnimator : UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
            else {
                return
        }
        
        transitionContext.containerView.insertSubview(toVC.view, belowSubview: fromVC.view)

        let screenBounds = UIScreen.main.bounds
        let bottomLeftCorner = CGPoint(x: 0, y: screenBounds.height)
        let finalFrame = CGRect(origin: bottomLeftCorner, size: screenBounds.size)
        
        UIView.animate(
            withDuration: transitionDuration(using: transitionContext),
            animations: {
                fromVC.view.frame = finalFrame
            },
            completion: { _ in
                transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            }
        )
    }
}

// MARK: - ViewController extension

extension UIViewController: UIViewControllerTransitioningDelegate {
    
    public static let interactorAssociation = ObjectAssociation<NSObject>()
    
    // MARK: - Inspectables
    
    public var interactor: AwesomeMediaInteractor? {
        get {
            return UIViewController.interactorAssociation[self] as? AwesomeMediaInteractor
        }
        set (interactor) {
            UIViewController.interactorAssociation[self] = interactor
        }
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return AwesomeMediaDismissAnimator()
    }
    
    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactor?.hasStarted ?? false ? interactor : nil
    }
}
