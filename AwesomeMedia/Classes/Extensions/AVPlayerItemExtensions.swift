//
//  AVPlayerItemExtension.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/9/18.
//

import AVFoundation

extension AVPlayerItem {
    
    public var durationInSeconds: Float {
        return Float(CMTimeGetSeconds(duration))
    }
    
    public var currentTimeInSeconds: Float {
        return Float(currentTime().seconds)
    }
    
    public var minTimeString: String {
        return Float64(currentTime().seconds).formatedTime
    }
    
    public var maxTimeString: String {
        return Float64(durationInSeconds - currentTimeInSeconds).formatedTime
    }
}
