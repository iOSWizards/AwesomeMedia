//
//  AwesomeMediaTrackingNotificationCenter.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 5/7/18.
//

import Foundation

public enum AwesomeMediaTrackingSource: String {
    case unknown
    case videoCell
    case videoFullscreen
    case audioCell
    case audioFullscreen
    case audioMiniplayer
    case imageCell
    case fileCell
    case controlCenter
}

public enum AwesomeMediaTrackingEvent: String {
    case startedPlaying
    case stoppedPlaying
    case sliderChanged
    case toggleFullscreen
    case closeFullscreen
    case openedMarkers
    case closedMarkers
    case selectedMarker
    case toggledSpeed
    case tappedRewind
    case tappedAdvance
    case tappedAirplay
    case changedOrientation
    case openedFullscreenWithRotation
    case tappedDownload
    case deletedDownload
    case timedOut
    case timeoutCancel
    case timeoutWait
    case playingInBackground
}

public struct AwesomeMediaTrackingObject {
    public var source: AwesomeMediaTrackingSource = .unknown
    public var value: Any?
    public var params = AwesomeMediaParams()
}

func track(event: AwesomeMediaTrackingEvent,
           source: AwesomeMediaTrackingSource,
           params: AwesomeMediaParams = AwesomeMediaManager.shared.mediaParams,
           value: Any? = nil) {
    //AwesomeMedia.log("notification tracking event: \(event.rawValue) source: \(object.source.rawValue)")
    
    AwesomeMediaTrackingNotificationCenter.shared.notify(event, object: AwesomeMediaTrackingObject(source: source, value: value, params: params))
}

public class AwesomeMediaTrackingNotificationCenter: NotificationCenter {
    
    public static var shared = AwesomeMediaTrackingNotificationCenter()
    
    public func notify(_ event: AwesomeMediaTrackingEvent, object: AwesomeMediaTrackingObject) {
        post(name: Notification.Name(rawValue: event.rawValue), object: object)
    }
    
    public func addObserver(_ observer: Any, selector: Selector, event: AwesomeMediaTrackingEvent, object: AnyObject? = nil) {
        addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: event.rawValue), object: object)
    }
    
    public static func addObservers(to: AwesomeMediaTrackingObserver) {
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .startedPlaying, event: .startedPlaying)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .stoppedPlaying, event: .stoppedPlaying)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .sliderChanged, event: .sliderChanged)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .toggleFullscreen, event: .toggleFullscreen)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .closeFullscreen, event: .closeFullscreen)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .openedMarkers, event: .openedMarkers)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .closedMarkers, event: .closedMarkers)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .selectedMarker, event: .selectedMarker)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .toggledSpeed, event: .toggledSpeed)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .tappedRewind, event: .tappedRewind)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .tappedAdvance, event: .tappedAdvance)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .tappedAirplay, event: .tappedAirplay)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .changedOrientation, event: .changedOrientation)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .openedFullscreenWithRotation, event: .openedFullscreenWithRotation)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .tappedDownload, event: .tappedDownload)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .deletedDownload, event: .deletedDownload)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .timedOut, event: .timedOut)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .timeoutCancel, event: .timeoutCancel)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .timeoutWait, event: .timeoutWait)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .playingInBackground, event: .playingInBackground)
    }
    
    public static func removeObservers(from: AwesomeMediaTrackingObserver) {
        AwesomeMediaNotificationCenter.shared.removeObserver(from)
    }
    
}
