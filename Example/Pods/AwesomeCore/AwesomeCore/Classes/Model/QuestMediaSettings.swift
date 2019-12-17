//
//  QuestMediaSettings.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 8/13/18.
//

import Foundation

public struct QuestMediaSettings : Codable, Equatable {
    
    public let zoomWebinarId: String?
    
}

// MARK: - Equatable

extension QuestMediaSettings {
    
    static public func ==(lhs: QuestMediaSettings, rhs: QuestMediaSettings) -> Bool {
        if lhs.zoomWebinarId != rhs.zoomWebinarId {
            return false
        }
        
        return true
    }
    
}
