//
//  AwesomeMediaControlOptionSet.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/10/18.
//

import Foundation

public struct AwesomeMediaVideoControls: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let time = AwesomeMediaVideoControls(rawValue: 1 << 0)
    public static let jumpto = AwesomeMediaVideoControls(rawValue: 1 << 1)
    public static let speed = AwesomeMediaVideoControls(rawValue: 1 << 2)
    public static let playlist = AwesomeMediaVideoControls(rawValue: 1 << 3)
    public static let fullscreen = AwesomeMediaVideoControls(rawValue: 1 << 4)
    public static let minimize = AwesomeMediaVideoControls(rawValue: 1 << 5)
    public static let rewind = AwesomeMediaVideoControls(rawValue: 1 << 6)
    public static let play = AwesomeMediaVideoControls(rawValue: 1 << 7)
    
    public static let standard: AwesomeMediaVideoControls = [.play, .time, .fullscreen]
    public static let all: AwesomeMediaVideoControls = [.play, .time, .jumpto, .speed, /*.playlist,*/ .minimize, .rewind]
}


public struct AwesomeMediaVideoStates: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let info = AwesomeMediaVideoStates(rawValue: 1 << 0)
    
    public static let standard: AwesomeMediaVideoStates = []
}
