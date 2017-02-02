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

extension Float {
    public var decimal: Float {
        return self.truncatingRemainder(dividingBy: floor(abs(self)))
    }
}

extension Float64 {
    public var formatedTime: String {
        return String(format: "%02d:%02d", ((lround(self) / 60) % 60), lround(self) % 60)
    }
    
    public func formatedTime(showHours: Bool = false) -> String {
        if showHours {
            return String(format: "%02d:%02d:%02d",
                          ((lround(self) / 3600) % 60),
                          ((lround(self) / 60) % 60),
                          lround(self) % 60)
        }else{
            return String(format: "%02d:%02d",
                          ((lround(self) / 60) % 60),
                          lround(self) % 60)
        }
    }
}
