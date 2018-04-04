//
//  Extensions.swift
//  Micro Learning App
//
//  Created by Evandro Harrison Hoffmann on 06/09/2016.
//  Copyright © 2016 Mindvalley. All rights reserved.
//

import UIKit

extension NSNumber {
    func toTimeString() -> String {
        
        let ti = NSInteger(self.doubleValue)
        
        //let ms = Int((self.doubleValue % 1) * 1000)
        let seconds = ti % 60
        let minutes = (ti / 60) % 60
        let hours = (ti / 3600)
        
        if hours > 0 {
            return String(format: "%0.2d:%0.2d", hours, minutes)
        }else if minutes > 0 {
            return String(format: "%0.2d min", minutes)
        }else if seconds > 0 {
            return String(format: "%0.2d seconds", seconds)
        }
        
        return ""
    }
}

