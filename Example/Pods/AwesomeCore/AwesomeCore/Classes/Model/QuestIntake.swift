//
//  QuestIntake.swift
//  Auth0-iOS10.0
//
//  Created by Maail on 12/04/2019.
//

import Foundation

public class QuestIntake: Codable, Equatable {
    
    public var userProgress: QuestUserProgress?
    public var releases: [QuestRelease]?
    
    init(userProgress: QuestUserProgress?,
         releases: [QuestRelease]?) {
        self.userProgress = userProgress
        self.releases = releases
    }
    
}

// MARK: - JSON Key

public struct QuestIntakeDataKey: Codable {
    
    public let data: QuestIntakeKey
    
}

public struct QuestIntakeKey: Codable {
    
    public let quest: QuestIntake
    
}

// MARK: - Equatable

extension QuestIntake {
    
    public static func ==(lhs: QuestIntake, rhs: QuestIntake) -> Bool {
        if lhs.userProgress != rhs.userProgress {
            return false
        }
        if lhs.releases != rhs.releases {
            return false
        }
        return true
    }
}

