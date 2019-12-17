//
//  QuestReleaseModel.swift
//  Pods
//
//  Created by Maail on 11/04/2019.
//

import Foundation

public struct QuestRelease: Codable, Equatable {
    
    public let id: String?
    public let courseStartedAt: String?
    public let courseEndedAt: String?
    public let enrollmentsCount: Int?
    
}

// MARK: - Equatable

extension QuestRelease {
    
    public static func ==(lhs: QuestRelease, rhs: QuestRelease) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.courseStartedAt != rhs.courseStartedAt {
            return false
        }
        if lhs.courseEndedAt != rhs.courseEndedAt {
            return false
        }
        if lhs.enrollmentsCount != rhs.enrollmentsCount {
            return false
        }
        return true
    }
}
