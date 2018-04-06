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
    
    // Testing Variables
    public static let testVideoURL = "https://overmind2.mvstg.com/api/v1/assets/0af656fc-dcde-45ad-9b59-7632ca247001.m3u8"
    
    func playMedia(withParams params: AwesomeMediaParams, inPlayerLayer playerLayer: AVPlayerLayer? = nil) {
        guard let urlParam = params.filter({ $0.key == .url }).first?.value as? String, let url = URL(string: urlParam) else {
            print("AwesomeMedia error: No URL provided")
            return
        }
        
        // prepare media
        if !isCurrentItem(withUrl: url) {
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
        
        addBufferObserver(forItem: playerItem)
        
        if play {
            avPlayer.play()
        }
    }
    
    fileprivate func isCurrentItem(withUrl url: URL) -> Bool {
        return ((avPlayer.currentItem?.asset) as? AVURLAsset)?.url == url
    }
    
}

// MARK: - Notifications

extension AwesomeMediaManager {
    
    // MARK: - Buffer observer
    
    fileprivate func addBufferObserver(forItem item: AVPlayerItem?) {
        guard let item = item else {
            return
        }
        
        item.addObserver(AwesomeMediaManager.shared, forKeyPath: "playbackLikelyToKeepUp", options: .new, context: nil)
        item.addObserver(AwesomeMediaManager.shared, forKeyPath: "playbackBufferFull", options: .new, context: nil)
        item.addObserver(AwesomeMediaManager.shared, forKeyPath: "playbackBufferEmpty", options: .new, context: nil)
        item.addObserver(AwesomeMediaManager.shared, forKeyPath: "status", options: [.new, .old], context: nil)
        item.addObserver(AwesomeMediaManager.shared, forKeyPath: "timeControlStatus", options: .new, context: nil)
    }
    
    public override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        switch avPlayer.timeControlStatus {
        case .waitingToPlayAtSpecifiedRate:
            AwesomeMedia.log("avPlayer.timeControlStatus: waiting \(avPlayer.reasonForWaitingToPlay ?? AVPlayer.WaitingReason(rawValue: ""))")
            if avPlayer.reasonForWaitingToPlay == .noItemToPlay {
                avPlayer.pause()
            }
        case .playing:
            AwesomeMediaNotificationCenter.shared.notify(.startedPlaying)
            AwesomeMedia.log("avPlayer.timeControlStatus: playing")
        case .paused:
            AwesomeMediaNotificationCenter.shared.notify(.pausedPlaying)
            AwesomeMedia.log("avPlayer.timeControlStatus: paused")
        }
        
        if keyPath == "status" {
            let status: AVPlayerItemStatus
            
            // Get the status change from the change dictionary
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItemStatus(rawValue: statusNumber.intValue)!
            } else {
                status = .unknown
            }
            
            // Switch over the status
            switch status {
            case .readyToPlay:
                AwesomeMedia.log("readyToPlay - playerItem is ready to play.")
            case .failed, .unknown:
                AwesomeMedia.log(".failed, .unknown - playerItem failed. See error.")
            }
        }
    }
}

