//
//  UIViewController+Quests.swift
//  Quests
//
//  Created by Evandro Harrison Hoffmann on 3/23/17.
//  Copyright © 2017 Mindvalley. All rights reserved.
//

import UIKit

extension UIApplication {

    public var topViewController: UIViewController? {
        if var topController = self.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController
        }

        return nil
    }

    public static var topViewController: UIViewController? {
        return UIApplication.shared.topViewController
    }

    public func vibrate(_ feedbackType: UINotificationFeedbackType) {
        if #available(iOS 10.0, *) {
            let generator = UINotificationFeedbackGenerator()
            generator.notificationOccurred(feedbackType)
        } else {
            // Fallback on earlier versions
        }
    }
}

import SafariServices
extension UIViewController: SFSafariViewControllerDelegate {
    
    public func presentWebPageInSafari(withURLString URLString: String) {
        
        if let url = URL(string: URLString) {
            if UIApplication.shared.canOpenURL(url) {
                let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
                vc.delegate = self
                self.present(vc, animated: true)
            }
        }
    }
    
    public func presentWebPageInSafari(withURL url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            let vc = SFSafariViewController(url: url, entersReaderIfAvailable: true)
            vc.delegate = self
            self.present(vc, animated: true)
        }
    }
    
    public func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}

import AVKit
import AVFoundation
extension UIViewController {

    public func openMedia(urlString: String?) {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            return
        }

        try? AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, with: [])
        let playerViewController = AVPlayerViewController()
        playerViewController.showsPlaybackControls = true
        playerViewController.player = AVPlayer(url: url)
        playerViewController.player?.play()

        present(playerViewController, animated: true, completion: {

        })
    }

    public func setLayoutsForPhoneX(constraints: [NSLayoutConstraint]) {
        for constraint in constraints {
            constraint.constant += 20
        }
    }
}
