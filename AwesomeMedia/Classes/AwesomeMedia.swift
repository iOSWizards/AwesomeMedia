//
//  AwesomeMedia.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/4/18.
//

import Foundation

public enum AwesomeMediaParamTypes {
    case url
    case coverUrl
    case author
    case name
    case duration
}

public typealias AwesomeMediaParams = [AwesomeMediaParamTypes: Any]

public class AwesomeMedia {
    
    public static var autoHideControlViewTime: Double = 3
    public static var autoHideControlViewAnimationTime: Double = 0.3
    
    public static var bundle: Bundle {
        return Bundle(for: AwesomeMedia.self)
    }
    
    public static func play(mediaWithParams params: AwesomeMediaParams) {
    
    }
}
