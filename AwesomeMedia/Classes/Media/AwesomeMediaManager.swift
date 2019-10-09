//
//  AwesomeMediaManager.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import AVFoundation
import AwesomeNetwork
import AwesomeTracking

public class AwesomeMediaManager: NSObject {
    
    public static var shared = AwesomeMediaManager()
    
    public var avPlayer = AVPlayer()
    
    // Private Variables
    fileprivate var timeObserver: AnyObject?
    fileprivate var playbackLikelyToKeepUpContext = 0
    fileprivate var playbackBufferFullContext = 1
    fileprivate var bufferTimer: Timer?
    
    // Public Variables
    public var bufferingState = [String: Bool]()
    public var mediaParams = AwesomeMediaParams()
    
    public func playMedia(withParams params: AwesomeMediaParams, reset: Bool = false, inPlayerLayer playerLayer: AVPlayerLayer? = nil, viewController: UIViewController? = nil) {
        
        guard let url = params.url?.url?.offlineURLIfAvailable else {
            AwesomeMedia.log("No URL provided")
            return
        }
        
        // In case there is a view controller and isn't reachable, return callback
        /*if let viewController = viewController, !(AwesomeNetwork.shared?.isReachable ?? false),
         !url.offlineFileExists {
         AwesomeMedia.log("No Internet connection")
         
         viewController.showNoConnectionAlert()
         return
         }*/
        
        // set current media params
        mediaParams = params
        
        // prepare media
        if !avPlayer.isCurrentItem(withUrl: url) || reset {
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
    
    public func prepareMedia(withUrl url: URL, andPlay play: Bool = true) {
        //avPlayer.attachBitmovinTracker()
        sharedAVPlayer.stop(resetTime: false)
        
        notifyMediaEvent(.buffering)
        AMAVPlayerItem.item(withUrl: url) { (playerItem) in
            notifyMediaEvent(.stoppedBuffering)
            
            //select current caption
            //AwesomeMediaManager.shared.mediaParams.currentCaption?.language
            
            // replace current item
            self.avPlayer.replaceCurrentItem(with: playerItem)
            
            // add observers for player and current item
            self.addObservers(withItem: playerItem)
            
            // at this point media will start buffering
            self.startedBuffering()
            
            // load saved media time
            playerItem.loadSavedTime()
            
            // start playing if the case
            if play {
                self.avPlayer.play()
            }
        }
    }
    
    // Media State
    
    public func mediaIsLoading(withParams params: AwesomeMediaParams) -> Bool {
        guard let url = params.url?.url?.offlineURLIfAvailable else {
            return false
        }
        
        guard sharedAVPlayer.isCurrentItem(withUrl: url) else {
            return false
        }
        
        return AwesomeMediaManager.shared.bufferingState[url.absoluteString] ?? false
    }
    
    public func updateMediaState(event: AwesomeMediaEvent) {
        if let url = sharedAVPlayer.currentItem?.url {
            switch event {
            case .buffering:
                bufferingState[url.absoluteString] = true
            case .stopped, .stoppedBuffering, .paused:
                bufferingState[url.absoluteString] = false
            default:
                break
            }
        }
    }
}

// MARK: - Notifications

extension AwesomeMediaManager {
    
    fileprivate func addObservers(withItem item: AMAVPlayerItem? = nil) {
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
    
    fileprivate func addBufferObserver(forItem item: AMAVPlayerItem?) {
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
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, preferredTimescale: 10)
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
                stoppedBuffering()
            } else {
                startedBuffering()
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
            var status: AVPlayerItem.Status = .unknown
            
            // Get the status change from the change dictionary
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
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
            
            // in case it's video, we can choose from the app to show or not mini player
            if mediaParams.shouldShowMiniPlayer {
                notifyMediaEvent(.showMiniPlayer, object: mediaParams as AnyObject)
            } else {
                notifyMediaEvent(.hideMiniPlayer, object: mediaParams as AnyObject)
            }
        } else {
            notifyMediaEvent(.playingAudio, object: mediaParams as AnyObject)
            
            if mediaParams.shouldShowMiniPlayer {
                notifyMediaEvent(.showMiniPlayer, object: mediaParams as AnyObject)
            } else {
                notifyMediaEvent(.hideMiniPlayer, object: mediaParams as AnyObject)
            }
            
            
        }
    }
    
    // Handle buffering
    
    fileprivate func startedBuffering() {
        notifyMediaEvent(.buffering)
        
        startBufferTimer()
    }
    
    fileprivate func stoppedBuffering() {
        notifyMediaEvent(.stoppedBuffering)
        
        cancelBufferTimer()
    }
    
    public func startBufferTimer() {
        cancelBufferTimer()
        bufferTimer = Timer.scheduledTimer(withTimeInterval: AwesomeMedia.bufferTimeout, repeats: false, block: { (timer) in
            notifyMediaEvent(.timedOut)
        })
    }
    
    public func cancelBufferTimer() {
        bufferTimer?.invalidate()
        bufferTimer = nil
    }
    
    // Finished Playing Observer
    
    @objc public func didFinishPlaying(){
        // tracking
        let dict: AwesomeTrackingDictionary = [:]
        if let courseId = mediaParams.params["courseId"] {
            dict.addElement(courseId, forKey: .courseID)
        }
        if let questId = mediaParams.params["questId"] {
            dict.addElement(questId, forKey: .questID)
        }
        if let assetId = mediaParams.params["assetId"] {
            dict.addElement(assetId, forKey: .assetID)
        }
        AwesomeTracking.track(.assetCompleted, with: dict)
        
        // stop playing
        sharedAVPlayer.stop(resetTime: true)
        
        notifyMediaEvent(.finished)
    }
}

