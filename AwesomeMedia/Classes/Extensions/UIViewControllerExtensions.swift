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
    
    public static let awesomeMediaOrientationAssociation = ObjectAssociation<NSObject>()
    
    // MARK: - Inspectables
    
    public var awesomeMediaOrientation: UIInterfaceOrientationMask {
        get {
            guard let orientation = UIViewController.awesomeMediaOrientationAssociation[self] as? UInt else {
                return .all
            }
            
            // if playing video, allows rotating
            guard !AwesomeMedia.shouldOverrideOrientation else {
                return .all
            }
            
            return UIInterfaceOrientationMask(rawValue: orientation)
        }
        set (awesomeMediaOrientation) {
            UIViewController.awesomeMediaOrientationAssociation[self] = awesomeMediaOrientation.rawValue as NSObject?
        }
    }
    
}

// MARK: - Safari Extensions

import SafariServices
extension UIViewController: SFSafariViewControllerDelegate {
    
    public func presentWebPageInSafari(withURLString URLString: String) {
        
        guard let url = URL(string: URLString) else{
            return
        }
        
        presentWebPageInSafari(withURL: url)
    }
    
    public func presentWebPageInSafari(withURL url: URL) {
        guard UIApplication.shared.canOpenURL(url) else {
            return
        }
        
        let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
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

// MARK: - Gets top controller

extension UIViewController {
    public static var topController: UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            return topController
        }
        
        return nil
    }
}
