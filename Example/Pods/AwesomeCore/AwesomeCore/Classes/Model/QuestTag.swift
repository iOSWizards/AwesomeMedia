//
//  QuestTag.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 7/23/18.
//

import Foundation

public struct QuestTag : Codable, Equatable {
    
    public let name: String?
    
}

// MARK: - Equatable

extension QuestTag {
    
    static public func ==(lhs: QuestTag, rhs: QuestTag) -> Bool {
        if lhs.name != rhs.name {
            return false
        }
        
        return true
    }
    
}
