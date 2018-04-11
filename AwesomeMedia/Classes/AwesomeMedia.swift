//
//  AwesomeMedia.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//

import Foundation

public class AwesomeMedia {
    
    // Configuration
    public static var autoHideControlViewTime: Double = 3
    public static var autoHideControlViewAnimationTime: Double = 0.3
    public static var shouldLockControlsWhenBuffering = true
    public static var showLogs = true
    public static var backwardForwardStep: Double = 10
    
    public static var bundle: Bundle {
        return Bundle(for: AwesomeMedia.self)
    }
    
    static func log(_ message: String){
        if AwesomeMedia.showLogs {
            print("AwesomeMedia \(message)")
        }
    }
}
