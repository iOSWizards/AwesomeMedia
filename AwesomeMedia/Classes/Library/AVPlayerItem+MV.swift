//
//  AVPlayerItem+MV.swift
//  Micro Learning App
//
//  Created by Evandro Harrison Hoffmann on 29/08/2016.
//  Copyright © 2016 Mindvalley. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

extension AVPlayerItem {

    public func elapsedTime(_ value: Float) -> Float64{
        return CMTimeGetSeconds(duration) * Float64(value)
    }
    
    public func remainingTime(_ value: Float) -> Float64 {
        return CMTimeGetSeconds(duration) - elapsedTime(value)
    }
    
}
