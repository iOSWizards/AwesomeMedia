//
//  AwesomeMediaTrackingNotificationCenter.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 5/7/18.
//

import Foundation
import AwesomeTracking

public enum AwesomeMediaTrackingSource: String {
    case unknown
    case videoCell = "Video content screen"
    case videoFullscreen = "Video full screen"
    case audioCell = "Audio content screen"
    case audioFullscreen = "Audio full screen"
    case audioMiniplayer = "Audio mini player"
    case imageCell = "Image content screen"
    case fileCell = "File content screen"
    case controlCenter = "Control center"
}

public struct AwesomeMediaTrackingObject {
    public var source: AwesomeMediaTrackingSource = .unknown
    public var value: Any?
    public var params = AwesomeMediaParams()
}

// MARK: - Tracking object extension

extension AwesomeMediaTrackingObject {
    
    var assetId: String? {
        return params.params["assetId"] as? String
    }
    
    var questId: Int32? {
        guard let questId = params.params["questId"] as? String else {
            return nil
        }
        
        return Int32(questId)
    }
}

func track(event: AwesomeTrackingEvent.AwesomeMedia,
           source: AwesomeMediaTrackingSource,
           params: AwesomeMediaParams = AwesomeMediaManager.shared.mediaParams,
           value: Any? = nil) {
    //AwesomeMedia.log("notification tracking event: \(event.rawValue) source: \(object.source.rawValue)")
    
    let trackingObject = AwesomeMediaTrackingObject(source: source, value: value, params: params)
    AwesomeMediaTrackingNotificationCenter.shared.notify(event, object: trackingObject)
    
    let dict: AwesomeTrackingDictionary = [:]
    dict.addElement(trackingObject.source.rawValue, forKey: .mediaSource)
    
    if let questId = trackingObject.questId {
        dict.addElement(questId, forKey: .questID)
    }
    if let assetId = trackingObject.assetId {
        dict.addElement(assetId, forKey: .assetID)
    }
    if let timeElapsed = trackingObject.value as? String {
        dict.addElement(timeElapsed, forKey: .timeElapsed)
    }
    
    AwesomeTracking.track(event, with: dict)
}

public class AwesomeMediaTrackingNotificationCenter: NotificationCenter {
    
    public static var shared = AwesomeMediaTrackingNotificationCenter()
    
    public func notify(_ event: AwesomeTrackingEvent.AwesomeMedia, object: AwesomeMediaTrackingObject) {
        post(name: Notification.Name(rawValue: event.rawValue), object: object)
    }
    
    public func addObserver(_ observer: Any, selector: Selector, event: AwesomeTrackingEvent.AwesomeMedia, object: AnyObject? = nil) {
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
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .openedCaptions, event: .openedCaptions)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .closedCaptions, event: .closedCaptions)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .selectedCaption, event: .selectedCaption)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .toggledSpeed, event: .toggledSpeed)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .tappedRewind, event: .tappedRewind)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .tappedAdvance, event: .tappedAdvance)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .tappedAirplay, event: .tappedAirplay)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .changedOrientation, event: .changedOrientation)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .openedFullscreenWithRotation, event: .openedFullscreenWithRotation)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .tappedDownload, event: .tappedDownload)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .deletedDownload, event: .deletedDownload)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .didTimeOut, event: .timedOut)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .timeoutCancel, event: .timeoutCancel)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .timeoutWait, event: .timeoutWait)
        AwesomeMediaTrackingNotificationCenter.shared.addObserver(to, selector: .playingInBackground, event: .playingInBackground)
    }
    
    public static func removeObservers(from: AwesomeMediaTrackingObserver) {
        AwesomeMediaNotificationCenter.shared.removeObserver(from)
    }
    
}
