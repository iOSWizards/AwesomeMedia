//
//  AwesomeMediaManager.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/5/18.
//

import AVFoundation

public class AwesomeMediaManager {
    
    public static var shared = AwesomeMediaManager()
    
    public var avPlayer = AVPlayer()
    
    // Testing Variables
    public static let testVideoURL = "https://overmind2.mvstg.com/api/v1/assets/0af656fc-dcde-45ad-9b59-7632ca247001.m3u8"
    
    func playMedia(withParams params: AwesomeMediaParams, inPlayerLayer playerLayer: AVPlayerLayer? = nil) {
        guard let urlParam = params.filter({ $0.key == .url }).first?.value as? String, let url = URL(string: urlParam) else {
            print("AwesomeMedia error: No URL provided")
            return
        }
        
        // prepare media
        if !isCurrentItem(withUrl: url) {
            prepareMedia(withUrl: url)
        } else {
            avPlayer.play()
        }

        // add player to layer
        playerLayer?.player = avPlayer
    }
    
    fileprivate func prepareMedia(withUrl url: URL, andPlay play: Bool = true) {
        let playerItem = AVPlayerItem(url: url)
        avPlayer.replaceCurrentItem(with: playerItem)
        
        if play {
            avPlayer.play()
        }
    }
    
    fileprivate func isCurrentItem(withUrl url: URL) -> Bool {
        return ((avPlayer.currentItem?.asset) as? AVURLAsset)?.url == url
    }
    
}

