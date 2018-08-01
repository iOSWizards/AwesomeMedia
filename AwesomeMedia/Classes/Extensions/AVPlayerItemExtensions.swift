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
        if subtitleUrl != nil {
            compositionItem(withUrl: url, andCaptionUrl: subtitleUrl, completion: completion)
        } else {
            urlItem(withUrl: url, completion: completion)
        }
    }
    
    public static func urlItem(withUrl url: URL, andCaptionUrl subtitleUrl: URL? = nil, completion: @escaping (AMAVPlayerItem) -> Void) {
        DispatchQueue.global(qos: .background).async {
            var playerItem = AMAVPlayerItem(url: url)
            
            let subtitles = playerItem.tracks(type: .subtitle)
            if let selectedSubtitle = playerItem.selected(type: .subtitle) {
                print("\(playerItem.select(type: .subtitle, name: selectedSubtitle))")
            }

            //let audio = playerItem.tracks(type: .audio)
            
            
            DispatchQueue.main.async {
                completion(playerItem)
            }
        }
    }
    
    public static func compositionItem(withUrl url: URL, andCaptionUrl subtitleUrl: URL? = nil, completion: @escaping (AMAVPlayerItem) -> Void) {
        DispatchQueue.global(qos: .background).async {
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

extension AVPlayerItem {
    
    enum TrackType {
        case subtitle
        case audio
        
        /**
         Return valid AVMediaSelectionGroup is item is available.
         */
        fileprivate func characteristic(item:AVPlayerItem) -> AVMediaSelectionGroup?  {
            let str = self == .subtitle ? AVMediaCharacteristic.legible : AVMediaCharacteristic.audible
            if item.asset.availableMediaCharacteristicsWithMediaSelectionOptions.contains(str) {
                return item.asset.mediaSelectionGroup(forMediaCharacteristic: str)
            }
            return nil
        }
    }
    
    func tracks(type:TrackType) -> [String] {
        if let characteristic = type.characteristic(item: self) {
            return characteristic.options.map { $0.displayName }
        }
        return [String]()
    }
    
    func selected(type:TrackType) -> String? {
        guard let group = type.characteristic(item: self) else {
            return nil
        }
        let selected = self.selectedMediaOption(in: group)
        return selected?.displayName
    }
    
    func select(type:TrackType, name:String) -> Bool {
        guard let group = type.characteristic(item: self) else {
            return false
        }
        guard let matched = group.options.filter({ $0.displayName == name }).first else {
            return false
        }
        self.select(matched, in: group)
        return true
    }
}
