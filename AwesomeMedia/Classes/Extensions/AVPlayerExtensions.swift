//
//  AVPlayerExtensions.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/10/18.
//

import AVFoundation

public var sharedAVPlayer: AVPlayer {
    return AwesomeMediaManager.shared.avPlayer
}

extension AVPlayer {
    
    public func isCurrentItem(withUrl url: URL?) -> Bool {
        guard let url = url else {
            return false
        }
        
        return ((currentItem?.asset) as? AVURLAsset)?.url == url
    }
    
    public func currentItem(ifSameUrlAs url: URL?) -> AVPlayerItem? {
        guard let url = url else {
            return nil
        }
        
        guard isCurrentItem(withUrl: url) else {
            return nil
        }
        
        return currentItem
    }
    
    public func currentItem(withParams params: AwesomeMediaParams) -> AVPlayerItem? {
        return currentItem(ifSameUrlAs: AwesomeMediaManager.url(forParams: params))
    }
    
    public func isCurrentItem(withParams params: AwesomeMediaParams) -> Bool {
        return isCurrentItem(withUrl: AwesomeMediaManager.url(forParams: params))
    }
    
    public var isPlaying: Bool {
        return rate != 0
    }
    
    public func isPlaying(withUrl url: URL) -> Bool {
        return isCurrentItem(withUrl: url) && isPlaying
    }
    
    // MARK: - Controls
    public func seek(toTime time: Double, pausing: Bool = true) {
        if pausing {
            sharedAVPlayer.pause()
        }
        
        currentItem?.seek(to: CMTime(seconds: time, preferredTimescale: currentTime().timescale))
        
        AwesomeMediaNotificationCenter.shared.notify(.timeUpdated, object: currentItem)
    }
    
    public func seek(withStep step: Double) {
        var time = CMTimeGetSeconds(currentTime()) + step
        
        if time <= 0 {
            time = 0
        } else if time >= Double(currentItem?.durationInSeconds ?? 0) {
            time = Double(currentItem?.durationInSeconds ?? 0)
        }
        
        seek(toTime: time, pausing: false)
    }
    
    public func seekBackward(step: Double = AwesomeMedia.backwardForwardStep) {
        seek(withStep: -step)
    }
    
    public func seekForward(step: Double = AwesomeMedia.backwardForwardStep) {
        seek(withStep: step)
    }
    
    public func stop() {
        pause()
        replaceCurrentItem(with: nil)
        AwesomeMediaNotificationCenter.shared.notify(.stopedPlaying)
    }
        
}
