//
//  NumberExtensions.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/9/18.
//

import Foundation

extension Float {
    
    public var isHours: Bool {
        return Float64(self).isHours
    }
}

extension Float64 {
    
    public var isHours: Bool {
        return ((lround(self) / 3600) % 60) > 0
    }
    
    public var formatedTime: String {
        if isHours {
            return formatedTimeInHours
        }else{
            return formatedTimeInMinutes
        }
    }
    
    public var formatedTimeInHours: String {
        return String(format: "%02d:%02d:%02d",
                      ((lround(self) / 3600) % 60),
                      ((lround(self) / 60) % 60),
                      lround(self) % 60)
    }
    
    public var formatedTimeInMinutes: String {
        return String(format: "%02d:%02d",
                      ((lround(self) / 60) % 60),
                      lround(self) % 60)
    }
}

extension Int {
    public var timeString: String {
        
        let ti = NSInteger(self)
        
        //let ms = Int((self.doubleValue % 1) * 1000)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        if hours > 0 {
            var timeString = "\(hours) \(hours == 1 ? "hour".localized(bundle: AwesomeMedia.bundle) : "hours".localized(bundle: AwesomeMedia.bundle))"
            if minutes > 0 {
                timeString.append(" \(minutes) \(minutes == 1 ? "minute".localized(bundle: AwesomeMedia.bundle) : "minutes".localized(bundle: AwesomeMedia.bundle))")
            }
            return timeString
        } else if minutes > 0 {
            return "\(minutes) \(minutes == 1 ? "min".localized(bundle: AwesomeMedia.bundle) : "mins".localized(bundle: AwesomeMedia.bundle))"
        } else if seconds > 0 {
            return "\(seconds) \(seconds == 1 ? "seconds".localized(bundle: AwesomeMedia.bundle) : "seconds".localized(bundle: AwesomeMedia.bundle))"
        }
        
        return ""
    }
    
}
