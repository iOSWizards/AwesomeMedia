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
    
    func playMedia(withParams params: AwesomeMediaParams) {
        guard let urlParam = params.filter({ $0.key == .url }).first?.value as? String, let url = URL(string: urlParam) else {
            print("AwesomeMedia error: No URL provided")
            return
        }
        
        let playerItem = AVPlayerItem(url: url)
        
        avPlayer.replaceCurrentItem(with: playerItem)
        avPlayer.play()
    }
}

