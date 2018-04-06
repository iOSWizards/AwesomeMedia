//
//  AwesomeMediaNotificationCenter.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/6/18.
//

import Foundation

public enum AwesomeMediaEvent: String {
    case startedPlaying
    case pausedPlaying
    case stopedPlaying
    case finishedPlaying
    case failedPlaying
    case startedBuffering
    case stopedBuffering
    case timeUpdated
    case timedOut
    case timeStartedUpdating
    case timeFinishedUpdating
    case isGoingPortrait
    case isGoingLandscape
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
