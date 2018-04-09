//
//  NumberExtensions.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/9/18.
//

import Foundation

extension Float64 {
    
    public var formatedTime: String {
        if ((lround(self) / 3600) % 60) > 0 {
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
