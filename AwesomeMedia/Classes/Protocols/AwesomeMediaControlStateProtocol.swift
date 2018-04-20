//
//  AwesomeMediaControlStateProtocol.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/20/18.
//

import Foundation

public protocol AwesomeMediaControlState {
    var isLocked: Bool {get set}
    
    func lock(_ lock: Bool, animated: Bool)
    func setLockedState(locked: Bool)
}
