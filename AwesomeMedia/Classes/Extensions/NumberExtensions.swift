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
