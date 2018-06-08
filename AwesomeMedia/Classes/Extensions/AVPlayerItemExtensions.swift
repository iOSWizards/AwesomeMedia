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
        guard var url = url else {
            return
        }
        
        url.time = currentTimeInSeconds
    }
    
    public func loadSavedTime() {

        if let time = url?.time {
            seek(to: CMTime(seconds: Double(time), preferredTimescale: currentTime().timescale))
        }
    }
    
    public func resetTime() {
        guard var url = url else {
            return
        }
        
        url.time = 0
    }
    
    public var url: URL? {
        if let asset = self.asset as? AVURLAsset {
            // for normal media, we just return the asset url if AVURLAsset
            return asset.url
        } else if self.asset is AVComposition {
            // for subtitled media, we return the asset url from shared media params
            return AwesomeMediaManager.shared.mediaParams.url?.url
        }
        
        return nil
    }
    
    // Captions
    
    public func setCaption(_ caption: AwesomeMediaCaption?, mediaParams: AwesomeMediaParams) {
        saveTime()
        
        var mediaParams = mediaParams
        mediaParams.currentCaption = caption
        
        sharedAVPlayer.pause()
        
        if let url = mediaParams.url?.url {
            AwesomeMediaManager.shared.prepareMedia(withUrl: url)
        }
        
        /*if let composition = self.asset as? AVMutableComposition,
            let textTrack = composition.tracks(withMediaType: .text).first {
            composition.removeTrack(textTrack)
            
            if let captionUrl = caption?.url.url {
                AVAsset.configureAsset(for: composition, url: captionUrl, ofType: .text)
            }
        }*/
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
    
    // Item
    
    public static func item(withUrl url: URL, andCaptionUrl subtitleUrl: URL? = nil, completion: @escaping (AMAVPlayerItem) -> Void) {
        DispatchQueue.global(qos: .background).async {
            /*guard let subtitleUrl = subtitleUrl else {
                let playerItem = AMAVPlayerItem(url: url)
                
                DispatchQueue.main.async {
                    completion(playerItem)
                }
                return
            }*/
            
            // Create a Mix composition
            let mixComposition = AVMutableComposition()
            
            // Configure Video Track
            AVAsset.configureAsset(for: mixComposition, url: url, ofType: .video)
            
            // Configure Audio Track
            AVAsset.configureAsset(for: mixComposition, url: url, ofType: .audio)
            
            // Configure Caption Track
            if let subtitleUrl = subtitleUrl {
                AVAsset.configureAsset(for: mixComposition, url: subtitleUrl, ofType: .text)
            }
            
//            let captionSelectionGroup = AVMediaSelectionGroup()
//            let option = AVMediaSelectionOption()
//            option.
//            
            DispatchQueue.main.async {
                completion(AMAVPlayerItem(asset: mixComposition))
            }
        }
        
    }
    
}
