//
//  AwesomeMediaTime.swift
//  AwesomeLoading
//
//  Created by Evandro Harrison Hoffmann on 4/13/18.
//

import Foundation

public struct AwesomeMediaTime {
    
    public static var speed: Float? {
        get {
            return UserDefaults.standard.float(forKey: "awesomeMediaSpeed")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "awesomeMediaSpeed")
        }
    }
    
}

extension URL {
    public var time: Float? {
        get {
            return UserDefaults.standard.float(forKey: self.pathComponents.last ?? self.absoluteString)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: self.pathComponents.last ?? self.absoluteString)
        }
    }
}
