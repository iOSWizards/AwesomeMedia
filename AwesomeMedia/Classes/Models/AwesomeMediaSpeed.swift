//
//  AwesomeMediaSpeed.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/24/18.
//

import Foundation

public enum AwesomeMediaSpeedOption: Float {
    case speed_075 = 0.75
    case speed_1 = 1
    case speed_125 = 1.25
    case speed_15 = 1.5
    case speed_175 = 1.75
    case speed_2 = 2
}

public var playbackSpeed: AwesomeMediaSpeedOption {
    set {
        UserDefaults.standard.set(newValue.rawValue, forKey: "awesomeMediaPlaybackSpeed")
    }
    get {
        return AwesomeMediaSpeedOption(rawValue: UserDefaults.standard.float(forKey: "awesomeMediaPlaybackSpeed")) ?? .speed_1
    }
}

public class AwesomeMediaSpeed {
    
    public static func toggleSpeed() {
        playbackSpeed = AwesomeMediaSpeed.nextSpeed(playbackSpeed)
    }
    
    public static func nextSpeed(_ speed: AwesomeMediaSpeedOption) -> AwesomeMediaSpeedOption {
        switch speed {
        case .speed_075: return .speed_1
        case .speed_1: return .speed_125
        case .speed_125: return .speed_15
        case .speed_15: return .speed_175
        case .speed_175: return .speed_2
        case .speed_2: return .speed_075
        }
    }
    
    public static var speedLabelForCurrentSpeed: String {
        switch playbackSpeed {
        case .speed_075: return " 0.75x  "
        case .speed_1: return "1x"
        case .speed_125: return " 1.25x  "
        case .speed_15: return " 1.5x  "
        case .speed_175: return " 1.75x  "
        case .speed_2: return "2x"
        }
    }
    
}


