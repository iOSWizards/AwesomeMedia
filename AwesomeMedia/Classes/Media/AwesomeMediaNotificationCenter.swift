//
//  AwesomeMediaNotificationCenter.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/6/18.
//

import Foundation
import AVFoundation

public enum AwesomeMediaEvent: String {
    case playing
    case paused
    case stopped
    case finished
    case failed
    case buffering
    case stoppedBuffering
    case timeUpdated
    case timedOut
    case timeStartedUpdating
    case timeFinishedUpdating
    case isGoingPortrait
    case isGoingLandscape
    case speedRateChanged
    case unknown
}

func notifyMediaEvent(_ event: AwesomeMediaEvent, object: AnyObject? = nil) {
    AwesomeMedia.log("notification event: \(event.rawValue)")
    
    AwesomeMediaNotificationCenter.shared.notify(event, object: object)
    
    if let url = (sharedAVPlayer.currentItem?.asset as? AVURLAsset)?.url {
        switch event {
        case .buffering, .playing, .stoppedBuffering:
            AwesomeMediaManager.shared.mediaState[url.absoluteString] = event
        default:
            break
        }
    }
}

public class AwesomeMediaNotificationCenter: NotificationCenter {
    
    public static var shared = AwesomeMediaNotificationCenter()
    
    public func notify(_ event: AwesomeMediaEvent, object: AnyObject? = nil) {
        post(name: Notification.Name(rawValue: event.rawValue), object: object)
    }
    
    public func addObserver(_ observer: Any, selector: Selector, event: AwesomeMediaEvent, object: AnyObject? = nil) {
        addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: event.rawValue), object: object)
    }
    
}
