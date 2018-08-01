//
//  AwesomeMedia.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//

import Foundation

public class AwesomeMedia {
    
    // Configuration
    public static var autoHideControlViewTime: Double = 3
    public static var autoHideControlViewAnimationTime: Double = 0.3
    public static var removeAudioControlViewTime: Double = 3
    public static var shouldLockControlsWhenBuffering = true
    public static var showLogs = true
    public static var backwardForwardStep: Double = 10
    public static var bufferTimeout: Double = 20
    public static var shouldStopVideoWhenCloseFullScreen: Bool = false
    
    public static var bundle: Bundle {
        return Bundle(for: AwesomeMedia.self)
    }
    
    static func log(_ message: String){
        if AwesomeMedia.showLogs {
            print("AwesomeMedia \(message)")
        }
    }
    
    public static func didEnterBackground() {
        sharedAVPlayer.currentItem?.playInBackground(true)
    }
    
    public static func didBecomeActive() {
        sharedAVPlayer.currentItem?.playInBackground(false)
    }
    
    public static var shouldOverrideOrientation: Bool {
        return sharedAVPlayer.isPlayingVideo && !AwesomeMediaVideoViewController.presentingVideoInFullscreen
    }
    
    public static func stopPlayingIfIsVideoAndNotFullscreen() {
        if shouldOverrideOrientation {
            sharedAVPlayer.stop()
        }
    }
    
    public static func openFullscreenVideoIfPlaying(mediaParamsArray: [AwesomeMediaParams], fromController viewController: UIViewController) {
        guard !UIApplication.shared.statusBarOrientation.isPortrait else {
            return
        }
        
        guard sharedAVPlayer.isPlayingVideo else {
            return
        }
        
        if let mediaParams  = sharedAVPlayer.playingMediaParams(ifPlayingAnyFrom: mediaParamsArray) {
            viewController.presentVideoFullscreen(withMediaParams: mediaParams)
        }
        
        // track event
        track(event: .openedFullscreenWithRotation, source: .unknown, value: UIApplication.shared.statusBarOrientation)
    }
    
    static func extractYoutubeVideoId(videoUrl: String) -> String? {
        
        if videoUrl.contains("youtu.be") {
            
            if let part = videoUrl.components(separatedBy: "v=").last {
                return part.components(separatedBy: "?").first?.components(separatedBy: "&").first
                
            }
            
            return videoUrl.components(separatedBy: "/").last
            
        } else if videoUrl.contains("youtube") {
            if let part = videoUrl.components(separatedBy: "v=").last {
                return part.components(separatedBy: "&").first
            }
        }
        
        return nil
    }
    
    public static func isYoutubeVideo(videoUrl: String?) -> Bool {
        guard let videoUrl = videoUrl else {
            return false
        }
        return videoUrl.contains("youtu.be") || videoUrl.contains("youtube")
    }
    
    
    public static var defaultSubtitle: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "awesomeMediaDefaultSubtitle")
        }
        get {
            return UserDefaults.standard.string(forKey: "awesomeMediaDefaultSubtitle")
        }
    }
}
