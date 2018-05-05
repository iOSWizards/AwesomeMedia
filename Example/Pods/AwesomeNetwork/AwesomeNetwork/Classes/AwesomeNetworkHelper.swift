//
//  AwesomeNetworkHelper.swift
//  AwesomeNetwork
//
//  Created by Evandro Harrison Hoffmann on 2/15/18.
//

import Foundation
import ReachabilitySwift

public struct AwesomeNetworkHelper {
    
    private let reachability = Reachability()
    
    // MARK: - AwesomeNetwork lifecycle
    
    public init() {
        print("AwesomeNetwork: init()")
    }
    
    public func startNetworkStateNotifier() {
        reachability?.whenReachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                if reachability.isReachable {
                    print("AwesomeNetwork: Reachable via \(reachability.currentReachabilityString)")
                    self.postNotification(with: .connected)
                }
            }
        }
        reachability?.whenUnreachable = { reachability in
            // this is called on a background thread, but UI updates must
            // be on the main thread, like this:
            DispatchQueue.main.async {
                print("AwesomeNetwork: Not reachable")
                self.postNotification(with: .disconnected)
            }
        }
        
        do {
            try reachability?.startNotifier()
        } catch {
            print("AwesomeNetwork: Unable to start notifier")
        }
    }
    
    public func stopNetworkStateNotifier() {
        reachability?.stopNotifier()
    }
    
    public func isWifiConnected(viewController: UIViewController,
                                noConnectionMessage: String,
                                okButtonTitle: String = "Ok",
                                onPress: (() -> Void)? = nil) -> Bool {
        if isReachable {
            if reachability?.isReachableViaWiFi ?? false {
                return true
            }
        }
        
        viewController.showAlert(message: noConnectionMessage, completion: {
        }, buttons: (UIAlertActionStyle.default, okButtonTitle, onPress))
        
        return false
    }
    
    // MARK: - State Notifier
    
    /*
     * True if Internet connection is reachable either by WiFi or Cellular and false in any other case.
     */
    public func isReachable(viewController: UIViewController,
                            noConnectionMessage: String,
                            okButtonTitle: String = "Ok",
                            onPress: (() -> Void)? = nil) -> Bool {
        if isReachable {
            return true
        }
        
        viewController.showAlert(message: noConnectionMessage, completion: {
        }, buttons: (UIAlertActionStyle.default, okButtonTitle, onPress))
        
        return false
    }
    
    public var isReachable: Bool {
        return reachability?.isReachable ?? false
    }
    
    public var isWifiReachable: Bool {
        return reachability?.isReachableViaWiFi ?? false && isReachable
    }
    
    public func addObserver(_ observer: Any, selector: Selector, event: NetworkStateEvent) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: notificationName(with: event), object: nil)
    }
    
    public func removeObserver(_ observer: Any) {
        NotificationCenter.default.removeObserver(observer)
    }
    
    // MARK: - Helpers
    
    private func postNotification(with event: NetworkStateEvent) {
        NotificationCenter.default.post(name: notificationName(with: event), object: nil)
    }
    
    private func notificationName(with event: NetworkStateEvent) -> NSNotification.Name {
        return NSNotification.Name(rawValue: event.rawValue)
    }
}
