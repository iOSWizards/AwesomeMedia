//
//  AwesomeMediaManager.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import AVFoundation

public class AwesomeMediaManager: NSObject {
    
    public static var shared = AwesomeMediaManager()
    
    public var avPlayer = AVPlayer()
    
    // Private Variables
    fileprivate var timeObserver: AnyObject?
    fileprivate var playbackLikelyToKeepUpContext = 0
    fileprivate var playbackBufferFullContext = 1
    fileprivate var mediaParams: AwesomeMediaParams = [:]
    
    // Public Variables
    public var bufferingState = [String: Bool]()
    
    // Testing Variables
    public static let testVideoURL = "https://overmind2.mvstg.com/api/v1/assets/0af656fc-dcde-45ad-9b59-7632ca247001.m3u8"
    public static let testMediaMarkers = [AwesomeMediaMarker(title: "Intro", time: 120),
                                          AwesomeMediaMarker(title: "About WildFit", time: 360),
                                          AwesomeMediaMarker(title: "Day 1", time: 420),
                                          AwesomeMediaMarker(title: "Test Marker 1", time: 422),
                                          AwesomeMediaMarker(title: "Test Marker 2", time: 424),
                                          AwesomeMediaMarker(title: "Test Marker 3", time: 426),
                                          AwesomeMediaMarker(title: "Test Marker 4", time: 428),
                                          AwesomeMediaMarker(title: "Test Marker 5", time: 430),
                                          AwesomeMediaMarker(title: "Test Marker 6", time: 440),
                                          AwesomeMediaMarker(title: "Test Marker 7", time: 441)]
    public static let testAudioURL = "https://archive.org/download/VirtualHaircut/virtualbarbershop.mp3"
    
    func playMedia(withParams params: AwesomeMediaParams, inPlayerLayer playerLayer: AVPlayerLayer? = nil) {
        guard let url = AwesomeMediaManager.url(forParams: params) else {
            AwesomeMedia.log("No URL provided")
            return
        }
        
        // set current media params
        mediaParams = params
        
        // prepare media
        if !avPlayer.isCurrentItem(withUrl: url) {
            prepareMedia(withUrl: url)
        } else {
            avPlayer.play()
            notifyPlaying()
        }

        // add player to layer
        playerLayer?.player = avPlayer
        
        //adjust speed
        avPlayer.adjustSpeed()
        
        // add remote controls
        AwesomeMediaControlCenter.configBackgroundPlay(withParams: params)
    }
    
    fileprivate func prepareMedia(withUrl url: URL, andPlay play: Bool = true) {
        let playerItem = AVPlayerItem(url: url)
        avPlayer.replaceCurrentItem(with: playerItem)
        
        // add observers for player and current item
        addObservers(withItem: playerItem)
        
        // at this point media will start buffering
        notifyMediaEvent(.buffering)
        
        // load saved media time
        playerItem.loadSavedTime()
        
        // start playing if the case
        if play {
            avPlayer.play()
        }
    }
    
    // Media State
    
    public func mediaIsLoading(withParams params: AwesomeMediaParams) -> Bool {
        guard let url = AwesomeMediaManager.url(forParams: params) else {
            return false
        }
        
        return AwesomeMediaManager.shared.bufferingState[url.absoluteString] ?? false
    }
}

// MARK: - Notifications

extension AwesomeMediaManager {
    
    fileprivate func addObservers(withItem item: AVPlayerItem? = nil) {
        addTimeObserver()
        addBufferObserver(forItem: item)
        
        avPlayer.addObserver(self, forKeyPath: "rate", options: .new, context: nil)
        
        // notification for didFinishPlaying
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AwesomeMediaManager.didFinishPlaying),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
    }
    
    // MARK: - Buffer observer
    
    fileprivate func addBufferObserver(forItem item: AVPlayerItem?) {
        guard let item = item else {
            return
        }
        
        item.addObserver(self, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: &playbackLikelyToKeepUpContext)
        item.addObserver(self, forKeyPath: "playbackBufferFull", options: .new, context: &playbackBufferFullContext)
        item.addObserver(self, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        item.addObserver(self, forKeyPath: "status", options: .new, context: nil)
        item.addObserver(self, forKeyPath: "timeControlStatus", options: .new, context: nil)
    }
    
    // MARK: - Time Observer
    
    fileprivate func addTimeObserver() {
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
        timeObserver = avPlayer.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) { (elapsedTime: CMTime) -> Void in
            self.observeTime(elapsedTime)
            } as AnyObject?
    }
    
    fileprivate func observeTime(_ elapsedTime: CMTime) {
        guard let currentItem = avPlayer.currentItem else {
            return
        }
        
        if CMTimeGetSeconds(currentItem.duration).isFinite {
            notifyMediaEvent(.timeUpdated)
        }
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        /*switch avPlayer.timeControlStatus {
        case .waitingToPlayAtSpecifiedRate:
            AwesomeMedia.log("avPlayer.timeControlStatus: waiting \(avPlayer.reasonForWaitingToPlay ?? AVPlayer.WaitingReason(rawValue: ""))")
            if avPlayer.reasonForWaitingToPlay == .noItemToPlay {
                avPlayer.pause()
            }
        default:
            break
//        case .playing:
//            notifyMediaEvent(.startedPlaying)
//            AwesomeMedia.log("avPlayer.timeControlStatus: playing")
//        case .paused:
//            notifyMediaEvent(.pausedPlaying)
//            AwesomeMedia.log("avPlayer.timeControlStatus: paused")
        }*/
        
        // Check for media buffering
        if context == &playbackLikelyToKeepUpContext || context == &playbackBufferFullContext {
            if let currentItem = sharedAVPlayer.currentItem, currentItem.isPlaybackLikelyToKeepUp || currentItem.isPlaybackBufferFull {
                notifyMediaEvent(.stoppedBuffering)
            } else {
                notifyMediaEvent(.buffering)
            }
        }
        
        // Check for Rate Changes
        if keyPath == "rate" {
            if avPlayer.isPlaying {
                notifyMediaEvent(.speedRateChanged)
            } else {
                notifyMediaEvent(.paused)
                sharedAVPlayer.currentItem?.saveTime()
            }
        }
        // Check for Status Changes
        else if keyPath == "status" {
            var status: AVPlayerItemStatus = .unknown
            
            // Get the status change from the change dictionary
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
            }
            
            switch status {
            case .readyToPlay:
                notifyPlaying()
            case .failed, .unknown:
                notifyMediaEvent(.failed)
            }
        }
    }
    
    fileprivate func notifyPlaying() {
        notifyMediaEvent(.playing)
        
        if sharedAVPlayer.currentItem?.isVideo ?? false {
            notifyMediaEvent(.playingVideo, object: mediaParams as AnyObject)
        } else {
            notifyMediaEvent(.playingAudio, object: mediaParams as AnyObject)
        }
    }
    
    // Finished Playing Observer
    
    @objc public func didFinishPlaying(){
        // stop playing
        sharedAVPlayer.stop(resetTime: true)
        
        notifyMediaEvent(.finished)
    }
}

