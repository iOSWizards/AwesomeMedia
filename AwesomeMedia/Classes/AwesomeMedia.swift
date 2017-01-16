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

public let kAwesomeMediaStartedPlaying = "kAwesomeMediaStartedPlaying"
public let kAwesomeMediaPausedPlaying = "kAwesomeMediaPausedPlaying"
public let kAwesomeMediaStopedPlaying = "kAwesomeMediaStopedPlaying"
public let kAwesomeMediaFinishedPlaying = "kAwesomeMediaFinishedPlaying"
public let kAwesomeMediaFailedPlaying = "kAwesomeMediaFailedPlaying"
public let kAwesomeMediaStartedBuffering = "kAwesomeMediaStartedBuffering"
public let kAwesomeMediaStopedBuffering = "kAwesomeMediaStopedBuffering"
public let kAwesomeMediaTimeUpdated = "kAwesomeMediaTimeUpdated"
public let kAwesomeMediaTimeStartedUpdating = "kAwesomeMediaTimeStartedUpdating"
public let kAwesomeMediaTimeFinishedUpdating = "kAwesomeMediaTimeFinishedUpdating"

public class AwesomeMedia: NSObject {
    
    public static let shared = AwesomeMedia()
    
    fileprivate var playbackLikelyToKeepUpContext = 0
    fileprivate var currentRate: Float = 0
    fileprivate var timeObserver: AnyObject?
    fileprivate var playHistory = [URL]()
    
    public let avPlayer = AVPlayer()
    public var avPlayerLayer = AVPlayerLayer()
    public let notificationCenter = NotificationCenter()
    public var playerSpeedOptions: [Float] = [0.75, 1, 1.25, 1.5, 2]
    public var playerIsPlaying: Bool {
        return avPlayer.rate > 0
    }
    
    public static func isPlaying(_ url: URL?) -> Bool {
        if AwesomeMedia.shared.avPlayer.rate == 0 {
            return false
        }
        
        guard let lastUrl = AwesomeMedia.shared.playHistory.last else {
            return false
        }
        
        return lastUrl == url
    }
    
    public func notify(_ name: String, object: AnyObject? = nil) {
        notificationCenter.post(name: Notification.Name(rawValue: name), object: object)
    }
}


// MARK: - Observers

extension AwesomeMedia {
    
    public func addObservers(){
        addBufferObserver()
        addTimeObserver()
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AwesomeMedia.didFinishPlaying(_:)),
                                               name: .AVPlayerItemDidPlayToEndTime,
                                               object: avPlayer.currentItem)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(AwesomeMedia.didFailPlaying(_:)),
                                               name: .AVPlayerItemFailedToPlayToEndTime,
                                               object: avPlayer.currentItem)
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
        let duration = CMTimeGetSeconds(AwesomeMedia.shared.avPlayer.currentItem!.duration)
        if duration.isFinite {
            notify(kAwesomeMediaTimeUpdated)
        }
    }
    
    // MARK: - Buffer observer
    
    fileprivate func removeBufferObserver(){
        AwesomeMedia.shared.avPlayer.removeObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp")
    }
    
    fileprivate func addBufferObserver(){
        avPlayer.addObserver(self, forKeyPath: "currentItem.playbackLikelyToKeepUp", options: .new, context: &playbackLikelyToKeepUpContext)
    }
    
    override open func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if context == &playbackLikelyToKeepUpContext {
            if AwesomeMedia.shared.avPlayer.currentItem!.isPlaybackLikelyToKeepUp {
                notify(kAwesomeMediaStopedBuffering)
                updateMediaInfo()
            } else {
                notify(kAwesomeMediaStartedBuffering)
            }
        }
    }
    
}

// MARK: - Events

extension AwesomeMedia {
    
    public func prepareMedia(withUrl url: URL?, replaceCurrent: Bool = false, startPlaying: Bool = false) -> Bool {
        guard let url = url else {
            return false
        }
        
        let playerItem = AVPlayerItem(url: url)
        
        //in case it's playing the same URL, only replace if is either paused or we are forcing replacing
        if playHistory.last == url {
            if avPlayer.rate == 0 || (avPlayer.rate != 0 && replaceCurrent) {
                avPlayer.replaceCurrentItem(with: playerItem)
            }
        }else{
            playHistory.append(url)
            
            avPlayer.replaceCurrentItem(with: playerItem)
        }
        
        //configure AVPlayerLayer
        avPlayerLayer.player = avPlayer
        avPlayerLayer.videoGravity = UI_USER_INTERFACE_IDIOM() == .pad ? AVLayerVideoGravityResizeAspect : AVLayerVideoGravityResizeAspectFill
        
        //Adds observers
        addObservers()
        
        //start playing right away if not a video as we want to improve it's quality before start playing
        if startPlaying && avPlayer.rate == 0 {
            play()
        }
        
        return true
    }
    
    public func play(){
        if avPlayer.currentItem == nil {
            return
        }
        avPlayer.play()
        
        if currentRate != 1 && currentRate != 0 {
            avPlayer.rate = currentRate
        }
        currentRate = avPlayer.rate
        
        updateMediaInfo()
        
        notify(kAwesomeMediaStartedPlaying)
    }
    
    public func pause(){
        if avPlayer.currentItem == nil {
            return
        }
        
        currentRate = avPlayer.rate
        avPlayer.pause()
        
        notify(kAwesomeMediaPausedPlaying)
    }
    
    public func stop(){
        if avPlayer.currentItem == nil {
            return
        }
        
        pause()
        
        //removes remote controls
        removePlayerControls()
        
        notify(kAwesomeMediaStopedPlaying)
    }
    
    public func didFinishPlaying(_ sender: AnyObject){
        notify(kAwesomeMediaFinishedPlaying)
    }
    
    public func didFailPlaying(_ sender: AnyObject){
        notify(kAwesomeMediaFailedPlaying)
    }
    
    public func togglePlay(){
        if avPlayer.currentItem == nil {
            return
        }
        
        let playerIsPlaying = avPlayer.rate > 0
        if playerIsPlaying {
            pause()
        } else {
            play()
        }
        
    }
    
    public func toggleRateSpeed() -> Float{
        if avPlayer.rate == 0 {
            return 1
        }
        
        var returnNext = false
        for playerSpeedOption in playerSpeedOptions {
            if returnNext {
                currentRate = playerSpeedOption
                return currentRate
            }
            
            returnNext = playerSpeedOption == currentRate
        }
        
        //if got here, means it was the last one, so pick the first item on the list
        currentRate = playerSpeedOptions.first ?? avPlayer.rate
        return currentRate
    }
}

// MARK: - Seek Slider Events

extension AwesomeMedia {
    
    public func sliderValueUpdated(_ timeSliderValue: Float){
        guard let currentItem = AwesomeMedia.shared.avPlayer.currentItem else {
            return
        }
        
        notify(kAwesomeMediaTimeUpdated, object: currentItem)
    }
    
    public func beginSeeking() {
        guard let currentItem = avPlayer.currentItem else {
            return
        }
        
        pause()
        
        notify(kAwesomeMediaTimeStartedUpdating, object: currentItem)
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
        
        notify(kAwesomeMediaTimeFinishedUpdating, object: currentItem)
    }
    
    public func seek(addingSeconds seconds: Double){
        guard let currentItem = avPlayer.currentItem else {
            return
        }
        
        let time = CMTimeMakeWithSeconds(CMTimeGetSeconds(avPlayer.currentTime()) + seconds, avPlayer.currentTime().timescale)
        avPlayer.currentItem?.seek(to: time)
        
        notify(kAwesomeMediaTimeUpdated, object: currentItem)
    }
    
    public func seek(toTime time: Double){
        guard let currentItem = avPlayer.currentItem else {
            return
        }
        
        avPlayer.currentItem?.seek(to: CMTime(seconds: time, preferredTimescale: avPlayer.currentTime().timescale))
        
        notify(kAwesomeMediaTimeUpdated, object: currentItem)
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
            //endSeeking(seekEvent.positionTime)
        }
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
    }
    
    // MARK: - Player controls
    
    public func addPlayerControls(){
        UIApplication.shared.beginReceivingRemoteControlEvents()
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        //play/pause
        commandCenter.pauseCommand.addTarget(self, action: #selector(AwesomeMedia.pause))
        commandCenter.playCommand.addTarget(self, action: #selector(AwesomeMedia.play))
        
        //seek forward
        commandCenter.seekForwardCommand.isEnabled = true
        commandCenter.seekForwardCommand.addTarget(self, action: #selector(AwesomeMedia.seekRemotely(_:)))
        
        //seek backward
        commandCenter.seekBackwardCommand.isEnabled = true
        commandCenter.seekBackwardCommand.addTarget(self, action: #selector(AwesomeMedia.seekRemotely(_:)))
    }
    
    public func removePlayerControls(){
        UIApplication.shared.endReceivingRemoteControlEvents()
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


