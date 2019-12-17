//
//  QuestGroup.swift
//  Auth0-iOS10.0
//
//  Created by Evandro Harrison Hoffmann on 12/19/18.
//

import Foundation

public struct QuestGroup: Codable, Equatable {
    
    public let description: String?
    public let id: String?
    public let locked: Bool?
    public let name: String?
    public let position: Int?
    public let unlockAfterDays: Int?
    public let secondsTillUnlock: Int?
    
}

// MARK: - Equatable

extension QuestGroup {
    public static func ==(lhs: QuestGroup, rhs: QuestGroup) -> Bool {
        if lhs.description != rhs.description {
            return false
        }
        if lhs.id != rhs.id {
            return false
        }
        if lhs.locked != rhs.locked {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if lhs.position != rhs.position {
            return false
        }
        if lhs.unlockAfterDays != rhs.unlockAfterDays {
            return false
        }
        if lhs.secondsTillUnlock != rhs.secondsTillUnlock {
            return false
        }
        
        return true
    }
}
