//
//  AwesomeMedia.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 16/01/2017.
//
//

import Foundation
import AVKit
import AVFoundation
import AudioToolbox
import MediaPlayer

public enum AwesomeMediaEvent: String {
    case startedPlaying = "startedPlaying"
    case pausedPlaying = "pausedPlaying"
    case stopedPlaying = "stopedPlaying"
    case finishedPlaying = "finishedPlaying"
    case failedPlaying = "failedPlaying"
    case startedBuffering = "startedBuffering"
    case stopedBuffering = "stopedBuffering"
    case timeUpdated = "timeUpdated"
    case timeStartedUpdating = "timeStartedUpdating"
    case timeFinishedUpdating = "timeFinishedUpdating"
    case isGoingPortrait = "isPortrait"
    case isGoingLandscape = "isLandscape"
    case appResignActive = "appResignActive"
}

public enum AMMediaType: String {
    case video = "Video"
    case audio = "Audio"
}

public class AwesomeMedia: NSObject {
    
    public static let shared = AwesomeMedia()
    public static var showLogs = false
    public static var shouldLockControlsWhenBuffering = true
    
    fileprivate var playbackLikelyToKeepUpContext = 0
    fileprivate var playbackBufferFullContext = 1
    fileprivate var timeObserver: AnyObject?
    fileprivate var playHistory = [URL]()
    public var currentRate: Float = 1
    
    public weak var playerDelegate: AwesomeMediaPlayerDelegate?
    
    public let avPlayer = AVPlayer()
    //public var avPlayerLayer = AVPlayerLayer()
    public let notificationCenter = NotificationCenter()
    public var playerSpeedOptions: [Float] = [0.75, 1, 1.25, 1.5, 2]
    public var skipTime: Int = 15
    public var preferredPeakBitRate: Double = 0
    public var preferredForwardBufferDuration: TimeInterval = 0
    
    // Configuration flags
    public var canUseNetworkResourcesForLiveStreamingWhilePaused: Bool = true
    public var isPlayingLandscapeMedia: Bool = false
    public var isPlayingYouTubeMedia: Bool = false
    public var shouldStopVideoOnApplicationDidEnterBackground: Bool = false
    public var shouldPauseVideoOnApplicationWillResignActive: Bool = false
    
    public var playerIsPlaying: Bool {
        return avPlayer.rate > 0
    }
    
    public var isPlayingVideo: Bool {
        return avPlayer.rate != 0 && avPlayer.error == nil && mediaType == .video
    }
    
    public func clearHistory() {
        if !AwesomeMedia.shared.playHistory.isEmpty {
            AwesomeMedia.shared.playHistory = [URL]()
        }
    }
    
    public var lastPlayedUrlString: String? {
        return playHistory.last?.absoluteString
    }
    
    public var mediaType: AMMediaType {
        if let currentItem = avPlayer.currentItem {
            if currentItem.asset.tracks(withMediaType: AVMediaTypeVideo).count > 0 {
                return .video
            } else if currentItem.asset.tracks(withMediaType: AVMediaTypeAudio).count > 0 {
                return .audio
            }
        }
        
        return .video
    }
    
    public static func isPlaying(_ url: URL?) -> Bool {
        if AwesomeMedia.shared.avPlayer.rate == 0 {
            return false
        }
        
        return wasPlaying(url)
    }
    
    public static func wasPlaying(_ url: URL?) -> Bool {
        guard let lastUrl = AwesomeMedia.shared.playHistory.last else {
            return false
        }
        
        return lastUrl == url
    }
    
    fileprivate func log(_ message: String){
        if AwesomeMedia.showLogs {
            print("AwesomeMedia \(message)")
        }
    }
    
    public static func applicationWillResignActive(_ application: UIApplication) {
        if AwesomeMedia.shared.isPlayingVideo && AwesomeMedia.shared.isPlayingLandscapeMedia &&
            AwesomeMedia.shared.shouldPauseVideoOnApplicationWillResignActive {
            AwesomeMedia.shared.pause()
        }
    }
    
    public static func applicationDidEnterBackground(_ application: UIApplication) {
        if AwesomeMedia.shared.isPlayingVideo {
            if AwesomeMedia.shared.shouldStopVideoOnApplicationDidEnterBackground {
                AwesomeMedia.shared.stop()
                
                // we're cleaning the Media Info when the Media Player is playing
                // a video and the app goes in background.
                AwesomeMedia.shared.mediaInfo = [String: AnyObject]()
                
            } else {
                AwesomeMedia.shared.pause()
            }
        }
    }
    
    static open func offlineFileDestination(withPath path: String?) -> URL? {
        guard let downloadPath = path else {
            return nil
        }
        
        guard let downloadUrl = URL(string: downloadPath) else {
            return nil
        }
        
        let documentsDirectoryURL =  FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
        return documentsDirectoryURL.appendingPathComponent(downloadUrl.lastPathComponent)
    }
}


// MARK: - Observers

extension AwesomeMedia {
    
    public func notify(_ event: AwesomeMediaEvent, object: AnyObject? = nil) {
        notificationCenter.post(name: Notification.Name(rawValue: event.rawValue), object: object)
    }
    
    public static func addObserver(_ observer: Any, selector: Selector, event: AwesomeMediaEvent){
        AwesomeMedia.shared.notificationCenter.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: event.rawValue), object: nil)
    }
    
    public static func removeObserver(_ observer: Any){
        AwesomeMedia.shared.notificationCenter.removeObserver(observer)
    }
    
    public func addObservers(){
        addBufferObserver()
        addTimeObserver()
        
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AwesomeMedia.rotated),
                                               name: NSNotification.Name.UIDeviceOrientationDidChange,
                                               object: nil)
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AwesomeMedia.didFinishPlaying(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AwesomeMedia.didFailPlaying(_:)),
                                               name: .AVPlayerItemFailedToPlayToEndTime,
                                               object: avPlayer.currentItem)
        
        let nftName = NSNotification.Name(
            rawValue: AwesomeMediaEvent.appResignActive.rawValue
        )
        notificationCenter.addObserver(
            self, selector: #selector(pause), name: nftName, object: nil
        )
    }
    
    // MARK: - Orientation Observers
    
    public func addOrientationObserverGoingLandscape(observer aObserver: Any, selector: Selector) {
        AwesomeMedia.addObserver(aObserver, selector: selector, event: .isGoingLandscape)
    }
    
    public func addOrientationObserverGoingPortrait(observer aObserver: Any, selector: Selector) {
        AwesomeMedia.addObserver(aObserver, selector: selector, event: .isGoingPortrait)
    }
    
    public func removeOrientationObservers(_ observer: Any) {
        AwesomeMedia.shared.notificationCenter.removeObserver(observer)
    }
    
    // MARK: - Time observer
    
    fileprivate func removeTimeObserver(){
        guard let timeObserver = timeObserver else {
            return
        }
        
        AwesomeMedia.shared.avPlayer.removeTimeObserver(timeObserver)
        timeObserver.invalidate()
        self.timeObserver = nil
    }
    
    fileprivate func addTimeObserver(){
        let timeInterval: CMTime = CMTimeMakeWithSeconds(1.0, 10)
        timeObserver = AwesomeMedia.shared.avPlayer.addPeriodicTimeObserver(forInterval: timeInterval, queue: DispatchQueue.main) { (elapsedTime: CMTime) -> Void in
            self.observeTime(elapsedTime)
            } as AnyObject?
    }
    
    fileprivate func observeTime(_ elapsedTime: CMTime) {
        guard let currentItem = AwesomeMedia.shared.avPlayer.currentItem else {
            return
        }
        
        let duration = CMTimeGetSeconds(currentItem.duration)
        if duration.isFinite {
            notify(.timeUpdated)
        }
    }
    
    // MARK: - Buffer observer
    
    fileprivate func removeBufferObserver(){
        AwesomeMedia.shared.avPlayer.removeObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp")
        AwesomeMedia.shared.avPlayer.removeObserver(self, forKeyPath: "currentItem.playbackBufferFull")
    }
    
    fileprivate func addBufferObserver(){
        avPlayer.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp", options: .new, context: &playbackLikelyToKeepUpContext)
        avPlayer.addObserver(self, forKeyPath: "currentItem.playbackBufferFull", options: .new, context: &playbackBufferFullContext)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == &playbackLikelyToKeepUpContext || context == &playbackBufferFullContext {
            if let currentItem = AwesomeMedia.shared.avPlayer.currentItem, currentItem.isPlaybackLikelyToKeepUp || currentItem.isPlaybackBufferFull {
                updateMediaInfo()
                if AwesomeMedia.shouldLockControlsWhenBuffering {
                    notify(.stopedBuffering)
                }
            } else {
                if AwesomeMedia.shouldLockControlsWhenBuffering {
                    notify(.startedBuffering)
                }
            }
        }
    }
    
}

// MARK: - Events

extension AwesomeMedia {
    
    public func prepareMedia(withUrl url: URL?, replaceCurrent: Bool = false, startPlaying: Bool = false, completion:(()->Void)? = nil) -> Bool {
        
        guard let url = url else {
            return false
        }
        
        if let completion = completion {
            
            DispatchQueue.global().async {
                
                _ = self.commonPrepareMedia(withUrl: url, replaceCurrent: replaceCurrent, startPlaying: startPlaying)
                
                DispatchQueue.main.async {
                    
                    if startPlaying && self.avPlayer.rate == 0 {
                        self.play()
                    }
                    
                    completion()
                }
            }
            
        } else {
            
            _ = commonPrepareMedia(withUrl: url, replaceCurrent: replaceCurrent, startPlaying: startPlaying)
            
            if startPlaying && avPlayer.rate == 0 {
                play()
            }
        }
        
        return true
    }
    
    private func commonPrepareMedia(withUrl url: URL, replaceCurrent: Bool = false, startPlaying: Bool = false) -> Bool {
        
        let playerItem = AVPlayerItem(url: url)
        
        //in case it's playing the same URL, only replace if is either paused or we are forcing replacing
        if self.playHistory.last == url {
            if self.avPlayer.rate != 0 && replaceCurrent {
                self.avPlayer.replaceCurrentItem(with: playerItem)
                self.log("replaced current item with url \(url)")
            }
        }else{
            self.log("replaced [\(self.playHistory.last?.absoluteString ?? "")] with url [\(url)]")
            
            self.playHistory.append(url)
            
            self.avPlayer.replaceCurrentItem(with: playerItem)
        }
        
        //configure AVPlayerLayer
        //avPlayerLayer.player = avPlayer
        //avPlayerLayer.videoGravity = UI_USER_INTERFACE_IDIOM() == .pad ? AVLayerVideoGravityResizeAspect : AVLayerVideoGravityResizeAspectFill
        
        //Adds observers
        self.addObservers()
        
        //Backgrond play
        self.configBackgroundPlay()
        
        //setup streaming speed
        if let currentItem = self.avPlayer.currentItem {
            currentItem.preferredPeakBitRate = self.preferredPeakBitRate
            if #available(iOS 10.0, *) {
                currentItem.preferredForwardBufferDuration = self.preferredForwardBufferDuration
                currentItem.canUseNetworkResourcesForLiveStreamingWhilePaused = self.canUseNetworkResourcesForLiveStreamingWhilePaused
            } else {
                // Fallback on earlier versions
            }
        }
        
        return true
    }
    
    public func play(){
        if avPlayer.currentItem == nil {
            return
        }
        avPlayer.play()
        
        if let speed = AwesomeMediaState.speedFor(AwesomeMedia.shared.mediaType) {
            currentRate = speed
        }
        
        if currentRate != 1 && currentRate != 0 {
            avPlayer.rate = currentRate
        }
        
        currentRate = avPlayer.rate
        
        updateMediaInfo()
        
        playerDelegate?.didStartPlaying(mediaType: mediaType)
        notify(.startedPlaying)
        
        log("started playing")
    }
    
    public func rotated() {
        if UIDeviceOrientationIsLandscape(UIDevice.current.orientation) {
            AwesomeMedia.shared.isPlayingLandscapeMedia = true
            notify(.isGoingLandscape)
        }
        
        if UIDeviceOrientationIsPortrait(UIDevice.current.orientation) {
            AwesomeMedia.shared.isPlayingLandscapeMedia = false
            notify(.isGoingPortrait)
        }
        
    }
    
    public func pause(){
        if avPlayer.currentItem == nil {
            return
        }
        
        currentRate = avPlayer.rate
        avPlayer.pause()
        
        playerDelegate?.didPausePlaying(mediaType: mediaType)
        notify(.pausedPlaying)
        
        log("paused")
    }
    
    public func stop(){
        if avPlayer.currentItem == nil {
            return
        }
        AwesomeMedia.shared.isPlayingLandscapeMedia = false
        
        pause()
        
        //removes remote controls
        removePlayerControls()
        
        playerDelegate?.didStopPlaying(mediaType: mediaType)
        notify(.stopedPlaying)
        
        log("stopped playing")
    }
    
    public func didFinishPlaying(_ sender: AnyObject){
        notify(.finishedPlaying)
        playerDelegate?.didFinishPlaying(mediaType: mediaType)
    }
    
    public func didFailPlaying(_ sender: AnyObject){
        notify(.failedPlaying)
        playerDelegate?.didFailPlaying(mediaType: mediaType)
    }
    
    public func togglePlay(){
        if avPlayer.currentItem == nil {
            return
        }
        
        log("toggled play")
        
        let playerIsPlaying = avPlayer.rate > 0
        if playerIsPlaying {
            pause()
        } else {
            play()
        }
    }
    
    public func toggleRateSpeed() -> Float{
        //        if avPlayer.rate == 0 {
        //            playerDelegate?.didChangeSpeed(to: 1)
        //            return 1
        //        }
        
        log("toggled speed rate")
        
        var returnNext = false
        for playerSpeedOption in playerSpeedOptions {
            if returnNext {
                currentRate = playerSpeedOption
                
                //if already playing, then change rate
                if avPlayer.rate != 0 {
                    avPlayer.rate = currentRate
                }
                
                playerDelegate?.didChangeSpeed(to: currentRate, mediaType: mediaType)
                return currentRate
            }
            
            returnNext = playerSpeedOption == currentRate
        }
        
        //if got here, means it was the last one, so pick the first item on the list
        currentRate = playerSpeedOptions.first ?? avPlayer.rate
        
        //if already playing, then change rate
        if avPlayer.rate != 0 {
            avPlayer.rate = currentRate
        }
        
        playerDelegate?.didChangeSpeed(to: currentRate, mediaType: mediaType)
        return currentRate
    }
    
    public func toggleRateSpeedBackward() -> Float{
        if avPlayer.rate == 0 {
            return 1
        }
        
        log("toggled speed rate backward")
        
        var returnNext = false
        for i in (0..<playerSpeedOptions.count).reversed() {
            if returnNext {
                currentRate = playerSpeedOptions[i]
                avPlayer.rate = currentRate
                return currentRate
            }
            
            returnNext = playerSpeedOptions[i] == currentRate
        }
        
        //if got here, means it was the first one, so pick the last item on the list
        currentRate = playerSpeedOptions.last ?? avPlayer.rate
        avPlayer.rate = currentRate
        return currentRate
    }
}

// MARK: - Seek Slider Events

extension AwesomeMedia {
    
    public func sliderValueUpdated(_ timeSliderValue: Float){
        guard let currentItem = AwesomeMedia.shared.avPlayer.currentItem else {
            return
        }
        
        playerDelegate?.didChangeSlider(to: Float(CMTimeMakeWithSeconds(currentItem.elapsedTime(timeSliderValue), 100).seconds), mediaType: mediaType)
        notify(.timeUpdated, object: currentItem)
        
        log("time slider updated with value \(timeSliderValue)")
    }
    
    public func beginSeeking() {
        guard let currentItem = avPlayer.currentItem else {
            return
        }
        
        pause()
        
        notify(.timeStartedUpdating, object: currentItem)
        
        log("time slider began seeking")
    }
    
    public func endSeeking(_ timeSliderValue: Float) {
        guard let currentItem = avPlayer.currentItem else {
            return
        }
        
        avPlayer.seek(to: CMTimeMakeWithSeconds(currentItem.elapsedTime(timeSliderValue), 100), completionHandler: { (completed: Bool) -> Void in
            if self.currentRate > 0 {
                self.play()
            }
        })
        
        playerDelegate?.didChangeSlider(to: Float(CMTimeMakeWithSeconds(currentItem.elapsedTime(timeSliderValue), 100).seconds), mediaType: mediaType)
        notify(.timeFinishedUpdating, object: currentItem)
        
        log("time slider ended seeking with value \(timeSliderValue)")
    }
    
    public func seek(addingSeconds seconds: Double){
        guard let currentItem = avPlayer.currentItem else {
            return
        }
        
        let time = CMTimeMakeWithSeconds(CMTimeGetSeconds(avPlayer.currentTime()) + seconds, avPlayer.currentTime().timescale)
        avPlayer.currentItem?.seek(to: time)
        
        notify(.timeUpdated, object: currentItem)
        
        log("seek with seconds \(seconds)")
    }
    
    public func skipForward(){
        seek(addingSeconds: Double(skipTime))
    }
    
    public func skipBackward(){
        seek(addingSeconds: -Double(skipTime))
    }
    
    public func seek(toTime time: Double){
        guard let currentItem = avPlayer.currentItem else {
            return
        }
        
        avPlayer.currentItem?.seek(to: CMTime(seconds: time, preferredTimescale: avPlayer.currentTime().timescale))
        
        notify(.timeUpdated, object: currentItem)
        
        log("seek to time \(time)")
    }
    
    public func currentTime() -> Double {
        if avPlayer.currentItem == nil {
            return 0
        }
        
        return avPlayer.currentItem!.currentTime().seconds
    }
    
    public func seekRemotely(_ seekEvent: MPSeekCommandEvent){
        if (seekEvent.type == .beginSeeking) {
            print("Begin Seeking")
            //beginSeeking()
        }else if (seekEvent.type == .endSeeking) {
            print("End Seeking")
            //endSeeking(Float(seekEvent.timestamp))
        }
        
        log("seeking remotely with event type \(seekEvent.type)")
    }
}


// MARK: - Background Play

extension AwesomeMedia {
    
    public func configBackgroundPlay(){
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
        }catch{
            print("Something went wrong creating audio session... \(error)")
            return
        }
        
        //controls
        addPlayerControls()
        
        log("background play configured")
    }
    
    // MARK: - Player controls
    
    public func addPlayerControls(){
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        //play/pause
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget(self, action: #selector(AwesomeMedia.pause))
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget(self, action: #selector(AwesomeMedia.play))
        
        commandCenter.stopCommand.isEnabled = true
        commandCenter.stopCommand.addTarget(self, action: #selector(AwesomeMedia.stop))
        
        commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget(self, action: #selector(AwesomeMedia.togglePlay))
        
        //seek
        commandCenter.seekForwardCommand.isEnabled = true
        commandCenter.seekForwardCommand.addTarget(self, action: #selector(AwesomeMedia.seekRemotely(_:)))
        
        commandCenter.seekBackwardCommand.isEnabled = true
        commandCenter.seekBackwardCommand.addTarget(self, action: #selector(AwesomeMedia.seekRemotely(_:)))
        
        //skip
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.addTarget(self, action: #selector(AwesomeMedia.skipForward))
        
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.addTarget(self, action: #selector(AwesomeMedia.skipBackward))
        
        log("added command center controls")
    }
    
    public func removePlayerControls(){
        UIApplication.shared.endReceivingRemoteControlEvents()
        log("removed command center controls")
    }
    
    // MARK: - Media Info Art
    
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
    
    public func addMediaInfo(_ author: String?, title: String?, coverImage: UIImage?){
        
        var nowPlayingInfo = mediaInfo
        
        if let author = author {
            nowPlayingInfo[MPMediaItemPropertyArtist] = author as AnyObject?
        }
        
        if let title = title {
            nowPlayingInfo[MPMediaItemPropertyTitle] = title as AnyObject?
        }
        
        if let coverImage = coverImage {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(image: coverImage)
        }
        
        mediaInfo = nowPlayingInfo
    }
    
    public func updateMediaInfo(_ item: AVPlayerItem? = AwesomeMedia.shared.avPlayer.currentItem){
        if let item = item {
            var nowPlayingInfo = mediaInfo
            
            nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: CMTimeGetSeconds(item.currentTime()) as Double)
            nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = NSNumber(value: CMTimeGetSeconds(item.duration) as Double)
            nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber(value: AwesomeMedia.shared.avPlayer.rate as Float)
            
            mediaInfo = nowPlayingInfo
        }
    }
    
}
