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
    
    // Testing Variables
    public static let testVideoURL = "https://overmind2.mvstg.com/api/v1/assets/0af656fc-dcde-45ad-9b59-7632ca247001.m3u8"
    
    func playMedia(withParams params: AwesomeMediaParams, inPlayerLayer playerLayer: AVPlayerLayer? = nil) {
        guard let url = AwesomeMediaManager.url(forParams: params) else {
            AwesomeMedia.log("No URL provided")
            return
        }
        
        // prepare media
        if !avPlayer.isCurrentItem(withUrl: url) {
            prepareMedia(withUrl: url)
        } else {
            avPlayer.play()
        }

        // add player to layer
        playerLayer?.player = avPlayer
    }
    
    fileprivate func prepareMedia(withUrl url: URL, andPlay play: Bool = true) {
        let playerItem = AVPlayerItem(url: url)
        avPlayer.replaceCurrentItem(with: playerItem)
        
        // add observers for player and current item
        addObservers(withItem: playerItem)
        
        // at this point media will start buffering
        AwesomeMedia.log("avPlayer.timeControlStatus: started buffering")
        AwesomeMediaNotificationCenter.shared.notify(.startedBuffering)
        
        // start playing if the case
        if play {
            avPlayer.play()
        }
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
            AwesomeMediaNotificationCenter.shared.notify(.timeUpdated)
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
//            AwesomeMediaNotificationCenter.shared.notify(.startedPlaying)
//            AwesomeMedia.log("avPlayer.timeControlStatus: playing")
//        case .paused:
//            AwesomeMediaNotificationCenter.shared.notify(.pausedPlaying)
//            AwesomeMedia.log("avPlayer.timeControlStatus: paused")
        }*/
        
        // Check for media buffering
        if context == &playbackLikelyToKeepUpContext || context == &playbackBufferFullContext {
            if let currentItem = sharedAVPlayer.currentItem, currentItem.isPlaybackLikelyToKeepUp || currentItem.isPlaybackBufferFull {
                AwesomeMedia.log("avPlayer.timeControlStatus: stopped buffering")
                AwesomeMediaNotificationCenter.shared.notify(.stopedBuffering)
            } else {
                AwesomeMedia.log("avPlayer.timeControlStatus: started buffering")
                AwesomeMediaNotificationCenter.shared.notify(.startedBuffering)
            }
        }
        
        // Check for Rate Changes
        if keyPath == "rate" {
            if avPlayer.isPlaying {
                AwesomeMediaNotificationCenter.shared.notify(.startedPlaying)
                AwesomeMedia.log("avPlayer.timeControlStatus: playing")
            } else {
                AwesomeMediaNotificationCenter.shared.notify(.pausedPlaying)
                AwesomeMedia.log("avPlayer.timeControlStatus: paused")
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
                AwesomeMedia.log("avPlayer.timeControlStatus: readyToPlay")
            case .failed, .unknown:
                AwesomeMedia.log("avPlayer.timeControlStatus: .failed, .unknown")
            }
        }
    }
    
    // Finished Playing Observer
    
    @objc public func didFinishPlaying(){
        AwesomeMedia.log("avPlayer.timeControlStatus: finished playing")
        AwesomeMediaNotificationCenter.shared.notify(.finishedPlaying)
    }
}

