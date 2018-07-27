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
extension UIViewController {
    
    func presentWebPageInSafari(withURLString URLString: String) {
        guard let url = URL(string: URLString) else{
            return
        }
        
        presentWebPageInSafari(withURL: url)
    }
    
    func presentWebPageInSafari(withURL url: URL) {
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

// MARK: - Open fullscreen media

extension UIViewController {
    public func handleOrientationChange(withMediaParams mediaParams: [AwesomeMediaParams]) {
        AwesomeMedia.openFullscreenVideoIfPlaying(mediaParamsArray: mediaParams, fromController: self)
        
    }
}

// MARK: - Alerts

extension UIViewController {
    
    func showAlert(withTitle title: String? = nil, message: String?,  completion: (() -> ())? = nil, buttons: (UIAlertActionStyle, String, (() -> ())?)...) {
        
        guard let message = message, message.count > 0 else {
            return
        }
        
        if #available(iOS 8.0, *){
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alertController.modalPresentationStyle = isPad ? .popover : .currentContext
            
            for button in buttons {
                alertController.addAction(UIAlertAction(title: button.1, style: button.0) { (_: UIAlertAction!) in
                    if let completion = completion { completion() }
                    if let actionBlock = button.2 { actionBlock() }
                })
            }
            self.present(alertController, animated: true, completion: nil)
        }else {
            // Handle prior iOS Versions
            
        }
    }
    
    func showMediaTimedOutAlert() {
        // track event
        track(event: .timedOut, source: .unknown)
        
        showMediaTimedOutAlert(onWait: {
            AwesomeMediaManager.shared.startBufferTimer()
        }, onCancel: {
            sharedAVPlayer.stop()
        })
    }
    
    
    func showMediaTimedOutAlert(onWait: @escaping () -> Void, onCancel: @escaping () -> Void) {
        // track event
        track(event: .timedOut, source: .unknown)
        
        showAlert(withTitle: "failed_to_play_title".localized(bundle: AwesomeMedia.bundle),
                  message: "failed_to_play".localized(bundle: AwesomeMedia.bundle),
                  buttons: (UIAlertActionStyle.default, "wait".localized(bundle: AwesomeMedia.bundle), {
                    onWait()
                    
                    // track event
                    track(event: .timeoutWait, source: .unknown)
                  }), (UIAlertActionStyle.destructive, "cancel".localized(bundle: AwesomeMedia.bundle), {
                    onCancel()
                    
                    // track event
                    track(event: .timeoutCancel, source: .unknown)
                  }))
    }
    
    func showNoConnectionAlert() {
        showAlert(withTitle: "no_internet_title".localized(bundle: AwesomeMedia.bundle),
                  message: "no_internet".localized(bundle: AwesomeMedia.bundle),
                  buttons: (UIAlertActionStyle.destructive, "ok".localized(bundle: AwesomeMedia.bundle), {
                    sharedAVPlayer.stop()
                  }))
    }
    
    func removeAlertIfPresent() {
        if let viewController = presentedViewController as? UIAlertController {
            viewController.dismiss(animated: true, completion: nil)
        }
    }
}
