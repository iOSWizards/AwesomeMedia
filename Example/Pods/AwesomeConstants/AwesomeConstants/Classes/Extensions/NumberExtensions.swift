//
//  NumberExtensions.swift
//  Quests
//
//  Created by Evandro Harrison Hoffmann on 3/31/17.
//  Copyright © 2017 Mindvalley. All rights reserved.
//

import Foundation

extension Double {
    public var timeString: String {

        let ti = NSInteger(self)

        //let ms = Int((self.doubleValue % 1) * 1000)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)

        if hours > 0 {
            return String(format: "%d \("hours".localized) %d \("minutes".localized) ", hours, minutes)
        } else if minutes > 0 {
            return String(format: "%d \("min".localized)", minutes)
        } else if seconds > 0 {
            return String(format: "%d \("seconds".localized)", seconds)
        }

        return ""
    }

}

extension Float {
    public var slicedHourMinuteSecond: String {

        let to = Int(self)

        let hours = Int(to) / 3600
        let minutes = Int(to) / 60 % 60
        let seconds = Int(to) % 60

        return String(format:"%02i:%02i:%02i", hours, minutes, seconds)
    }
}
