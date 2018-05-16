//
//  AVPlayerItemExtension.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/9/18.
//

import AVFoundation
import MediaPlayer

extension AVPlayerItem {
    
    public var durationInSeconds: Float {
        let durationInSeconds = Float(CMTimeGetSeconds(duration))
        return !durationInSeconds.isNaN ? durationInSeconds : 1
    }
    
    public var currentTimeInSeconds: Float {
        return Float(currentTime().seconds)
    }
    
    public var minTimeString: String {
        let time = Float64(currentTime().seconds)
        if durationInSeconds.isHours {
            return time.formatedTimeInHours
        }
        return time.formatedTimeInMinutes
    }
    
    public var maxTimeString: String {
        let time = Float64(durationInSeconds - currentTimeInSeconds)
        if durationInSeconds.isHours {
            return time.formatedTimeInHours
        }
        return time.formatedTimeInMinutes
    }
    
    // MARK: - Time
    
    public func saveTime() {
        guard var url = (asset as? AVURLAsset)?.url else {
            return
        }
        
        url.time = currentTimeInSeconds
    }
    
    public func loadSavedTime() {
        guard var url = (asset as? AVURLAsset)?.url else {
            return
        }
        
        if let time = url.time {
            seek(to: CMTime(seconds: Double(time), preferredTimescale: currentTime().timescale))
        }
    }
    
    public func resetTime() {
        guard var url = (asset as? AVURLAsset)?.url else {
            return
        }
        
        url.time = 0
    }
    
    // Video in background
    
    public var isVideo: Bool {
        for playerItemTrack in tracks {
            if playerItemTrack.assetTrack.hasMediaCharacteristic(
                AVMediaCharacteristic.visual) {
                return true
            }
        }
        
        return false
    }
    
    public func playInBackground(_ background: Bool) {
        for playerItemTrack in tracks {
            if playerItemTrack.assetTrack.hasMediaCharacteristic(
                AVMediaCharacteristic.visual) {
                
                // Disable the track.
                playerItemTrack.isEnabled = !background
            }
        }

        if background {
            AwesomeMediaPlayerLayer.shared.player = nil
            
            // track event
            if sharedAVPlayer.isPlaying {
                track(event: .playingInBackground, source: .unknown)
            }
        } else {
            AwesomeMediaPlayerLayer.shared.player = sharedAVPlayer
        }
    }
    
}
