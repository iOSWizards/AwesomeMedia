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
}
