import AVFoundation

// MARK: - Responsible for handling the KVO operations that happen on the AVPlayerItem.

public enum AwesomeMediaPlayerItemKeyPaths: String {
    case playbackLikelyToKeepUp
    case playbackBufferFull
    case playbackBufferEmpty
    case status
    case timeControlStatus
}

public class AMAVPlayerItem: AVPlayerItem {
    
    private var observersKeyPath = [String: NSObject?]()
    private var keysPathArray: [AwesomeMediaPlayerItemKeyPaths] = [.playbackLikelyToKeepUp, .playbackBufferFull, .playbackBufferEmpty, .status, .timeControlStatus]
    
    deinit {
        for (keyPath, observer) in observersKeyPath {
            if let observer = observer {
                self.removeObserver(observer, forKeyPath: keyPath)
            }
        }
    }
    
    override public func addObserver(_ observer: NSObject, forKeyPath keyPath: String, options: NSKeyValueObservingOptions = [], context: UnsafeMutableRawPointer?) {
        super.addObserver(observer, forKeyPath: keyPath, options: options, context: context)
        if let keyPathRaw = AwesomeMediaPlayerItemKeyPaths(rawValue: keyPath), keysPathArray.contains(keyPathRaw) {
            if let obj = observersKeyPath[keyPath] as? NSObject {
                self.removeObserver(obj, forKeyPath: keyPath)
                observersKeyPath[keyPath] = observer
            } else {
                observersKeyPath[keyPath] = observer
            }
        }
    }
    
    override public func removeObserver(_ observer: NSObject, forKeyPath keyPath: String, context: UnsafeMutableRawPointer?) {
        super.removeObserver(observer, forKeyPath: keyPath, context: context)
        observersKeyPath[keyPath] = nil
    }
    
    public override func removeObserver(_ observer: NSObject, forKeyPath keyPath: String) {
        super.removeObserver(observer, forKeyPath: keyPath)
        observersKeyPath[keyPath] = nil
    }
    
    // Item
    
    public static func item(withUrl url: URL, andCaptionUrl subtitleUrl: URL? = nil) -> AMAVPlayerItem {
        guard let subtitleUrl = subtitleUrl else {
            return AMAVPlayerItem(url: url)
        }
        
        // Create a Mix composition
        let mixComposition = AVMutableComposition()
        
        // Configure Video Track
        let videoAsset = AVAsset(url: url)
        let videoTrack = mixComposition.addMutableTrack(withMediaType: .video, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        if let ofTrack = videoAsset.tracks(withMediaType: .video).first {
            do {
                try videoTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, videoAsset.duration), of: ofTrack, at: kCMTimeZero)
            } catch {
                print("Failed inserting time range to video.")
            }
        }
        
        // Configure Caption Track
        let subtitleAsset = AVURLAsset(url: subtitleUrl)
        let subtitleTrack = mixComposition.addMutableTrack(withMediaType: .text, preferredTrackID: kCMPersistentTrackID_Invalid)
        
        if let ofTrack = subtitleAsset.tracks(withMediaType: .text).first {
            do {
                try subtitleTrack?.insertTimeRange(CMTimeRangeMake(kCMTimeZero, subtitleAsset.duration), of: ofTrack, at: kCMTimeZero)
            } catch {
                print("Failed inserting time range to subtitle.")
            }
        }
        
        return AMAVPlayerItem(asset: mixComposition)
    }
    
}
