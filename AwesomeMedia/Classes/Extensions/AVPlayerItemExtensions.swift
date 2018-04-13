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
    
    // MARK: - Control Center
    
    public var mediaInfo: [String: AnyObject]{
        get {
            let infoCenter = MPNowPlayingInfoCenter.default()
            
            if infoCenter.nowPlayingInfo == nil {
                infoCenter.nowPlayingInfo = [String: AnyObject]()
            }
            
            return infoCenter.nowPlayingInfo! as [String : AnyObject]
        }
        set{
            let infoCenter = MPNowPlayingInfoCenter.default()
            infoCenter.nowPlayingInfo = newValue
        }
    }
    
    public func updateControlCenter(withParams params: AwesomeMediaParams) {
        var nowPlayingInfo = mediaInfo
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: Double(currentTimeInSeconds))
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = NSNumber(value: Double(durationInSeconds))
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber(value: sharedAVPlayer.rate)
        
        if let author = AwesomeMediaManager.author(forParams: params) {
            nowPlayingInfo[MPMediaItemPropertyArtist] = author as AnyObject?
        }
        
        if let title = AwesomeMediaManager.title(forParams: params) {
            nowPlayingInfo[MPMediaItemPropertyTitle] = title as AnyObject?
        }
        
        if let coverImageUrl = AwesomeMediaManager.coverUrl(forParams: params) {
            UIImage.loadImage(coverImageUrl.path, completion: { (image) in
                if let image = image {
                    nowPlayingInfo[MPMediaItemPropertyArtwork] =  MPMediaItemArtwork(image: image)
                }
            })
        }
    }
    
    public func resetControlCenter() {
        mediaInfo = [:]
    }
}
