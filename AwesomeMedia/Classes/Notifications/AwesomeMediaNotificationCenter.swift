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
    case playingAudio
    case playingVideo
    case showMiniPlayer
    case hideMiniPlayer
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
    case favourited
    case unfavourited
    case share
}

func notifyMediaEvent(_ event: AwesomeMediaEvent, object: AnyObject? = nil) {
    AwesomeMedia.log("notification event: \(event.rawValue)")
    
    AwesomeMediaNotificationCenter.shared.notify(event, object: object)
    
    AwesomeMediaManager.shared.updateMediaState(event: event)
}

public class AwesomeMediaNotificationCenter: NotificationCenter {
    
    public static var shared = AwesomeMediaNotificationCenter()
    
    public func notify(_ event: AwesomeMediaEvent, object: AnyObject? = nil) {
        post(name: Notification.Name(rawValue: event.rawValue), object: object)
    }
    
    public func addObserver(_ observer: Any, selector: Selector, event: AwesomeMediaEvent, object: AnyObject? = nil) {
        addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: event.rawValue), object: object)
    }
    
    public static func addObservers(_ options: AwesomeMediaNotificationCenterOptions, to: AwesomeMediaEventObserver) {
        
        if options.contains(.playing) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .playing, event: .playing)
        }
        
        if options.contains(.playingAudio) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .playingAudio, event: .playingAudio)
        }
        
        if options.contains(.playingVideo) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .playingVideo, event: .playingVideo)
        }
        
        if options.contains(.showMiniPlayer) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .showMiniPlayer, event: .showMiniPlayer)
        }
        
        if options.contains(.hideMiniPlayer) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .hideMiniPlayer, event: .hideMiniPlayer)
        }
        
        if options.contains(.paused) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .paused, event: .paused)
        }
        
        if options.contains(.stopped) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .stopped, event: .stopped)
        }
        
        if options.contains(.timeUpdated) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .timeUpdated, event: .timeUpdated)
        }
        
        if options.contains(.buffering) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .startedBuffering, event: .buffering)
        }
        
        if options.contains(.stoppedBuffering) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .stopedBuffering, event: .stoppedBuffering)
        }
        
        if options.contains(.finished) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .finishedPlaying, event: .finished)
        }
        
        if options.contains(.speedRateChanged) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .speedRateChanged, event: .speedRateChanged)
        }
        
        if options.contains(.timedOut) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .timedOut, event: .timedOut)
        }
        
        if options.contains(.favourited) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .favourited, event: .favourited)
        }
        
        if options.contains(.unfavourited) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .unfavourited, event: .unfavourited)
        }
        
        if options.contains(.share) {
            AwesomeMediaNotificationCenter.shared.addObserver(to, selector: .share, event: .share)
        }
    }
    
    public static func removeObservers(from: AwesomeMediaEventObserver) {
        AwesomeMediaNotificationCenter.shared.removeObserver(from)
    }
    
}

public struct AwesomeMediaNotificationCenterOptions: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let playing = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 0)
    public static let paused = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 1)
    public static let stopped = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 2)
    public static let finished = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 3)
    public static let failed = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 4)
    public static let buffering = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 5)
    public static let stoppedBuffering = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 6)
    public static let timeUpdated = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 7)
    public static let timedOut = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 8)
    public static let timeStartedUpdating = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 9)
    public static let timeFinishedUpdating = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 10)
    public static let isGoingPortrait = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 11)
    public static let isGoingLandscape = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 12)
    public static let speedRateChanged = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 13)
    public static let playingAudio = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 14)
    public static let playingVideo = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 15)
    public static let showMiniPlayer = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 16)
    public static let hideMiniPlayer = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 17)
    public static let unknown = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 18)
    public static let favourited = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 19)
    public static let unfavourited = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 20)
    public static let share = AwesomeMediaNotificationCenterOptions(rawValue: 1 << 21)
    
    public static let basic: AwesomeMediaNotificationCenterOptions = [.playing, .paused, .finished, .buffering, .stoppedBuffering]
}
