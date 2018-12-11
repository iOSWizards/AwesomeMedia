//
//  AwesomeMediaControlCenter.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/13/18.
//

import AVFoundation
import MediaPlayer

public class AwesomeMediaControlCenter {
    
    public static func configBackgroundPlay(withParams params: AwesomeMediaParams) {
       
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Something went wrong creating audio session... \(error)")
            return
        }
        
        //controls
        addPlayerControls()
        
        // update control center
        updateControlCenter(withParams: params)
    }
    
    // MARK: - Player controls
    
    public static func addPlayerControls() {
        DispatchQueue.main.async {
            UIApplication.shared.beginReceivingRemoteControlEvents()
        }
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        //play/pause
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            sharedAVPlayer.pause()
            
            return .success
        }
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            sharedAVPlayer.play()
            
            return .success
        }
        
        /*commandCenter.stopCommand.isEnabled = true
        commandCenter.stopCommand.addTarget(self, action: .ccStop)*/
        
        /*commandCenter.togglePlayPauseCommand.isEnabled = true
        commandCenter.togglePlayPauseCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }*/
        
        /*//seek
        commandCenter.seekForwardCommand.isEnabled = true
        commandCenter.seekForwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }
        
        commandCenter.seekBackwardCommand.isEnabled = true
        commandCenter.seekBackwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            return .success
        }*/
        
        //skip
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            sharedAVPlayer.seekForward(step: 15)
            
            return .success
        }
        
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.addTarget { (event) -> MPRemoteCommandHandlerStatus in
            sharedAVPlayer.seekBackward(step: 15)
            
            return .success
        }
    }
    
    public static func removePlayerControls(){
        UIApplication.shared.endReceivingRemoteControlEvents()
    }

    // MARK: - Media Info
    
    public static var mediaInfo: [String: AnyObject]{
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
    
    public static func updateControlCenter(withParams params: AwesomeMediaParams) {
        var nowPlayingInfo = mediaInfo
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = NSNumber(value: Double(sharedAVPlayer.currentItem?.currentTimeInSeconds ?? 0))
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = NSNumber(value: Double(sharedAVPlayer.currentItem?.durationInSeconds ?? 0))
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = NSNumber(value: sharedAVPlayer.rate)
        
        if let author = params.author {
            nowPlayingInfo[MPMediaItemPropertyArtist] = author as AnyObject?
        }
        
        if let title = params.title {
            nowPlayingInfo[MPMediaItemPropertyTitle] = title as AnyObject?
        }
        
        if let coverImageUrl = params.coverUrl {
            UIImage.loadImage(coverImageUrl, completion: { (image) in
                if let image = image {
                    nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork.init(boundsSize: image.size, requestHandler: { (size) -> UIImage in
                        return image
                    })
                }
            })
        }
        
        mediaInfo = nowPlayingInfo
    }
    
    public static func resetControlCenter() {
        mediaInfo = [:]
    }
}
