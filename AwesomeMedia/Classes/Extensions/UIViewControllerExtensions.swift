//
//  UIViewControllerExtensions.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/27/18.
//

import UIKit
import AwesomeUIMagic

// MARK: - Adds Interactor to ViewController

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

// MARK: - Adds Orientation Handling to ViewController

extension UIViewController {
    
    public static let awesomeOrientationAssociation = ObjectAssociation<NSObject>()
    
    // MARK: - Inspectables
    
    public var awesomeOrientation: UIInterfaceOrientationMask {
        get {
            guard let orientation = UIViewController.awesomeOrientationAssociation[self] as? UInt else {
                return .all
            }
            
            return UIInterfaceOrientationMask(rawValue: orientation)
        }
        set (awesomeOrientation) {
            UIViewController.awesomeOrientationAssociation[self] = awesomeOrientation.rawValue as NSObject?
        }
    }
}

// MARK: - Gestures

extension UIViewController {
    
    @IBAction public func handleGestureToDismissDown(_ sender: UIPanGestureRecognizer) {
        let percentThreshold: CGFloat = 0.3
        
        // convert y-position to downward pull progress (percentage)
        let translation = sender.translation(in: view)
        let verticalMovement = translation.y / view.bounds.height
        let downwardMovement = fmaxf(Float(verticalMovement), 0.0)
        let downwardMovementPercent = fminf(downwardMovement, 1.0)
        let progress = CGFloat(downwardMovementPercent)
        
        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            interactor.shouldFinish = progress > percentThreshold
            interactor.update(progress)
        case .cancelled:
            interactor.hasStarted = false
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }
    
}
