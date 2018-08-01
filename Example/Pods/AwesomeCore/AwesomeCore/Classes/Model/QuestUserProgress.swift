//
//  QuestUserProgress.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/2/17.
//

import Foundation

public struct QuestUserProgress: Codable, Equatable {
    
    public let id: String? // we're using Quest.id here, this way we can map this Model back and forth from Core Data
    public let currentDay: QuestPage?
    public let currentDayId: String?
    public let daysCompleted: [Int]
    public let ended: Bool
    public let endedAt: String?
    public let completed: Bool
    public let completedAt: String?
    public let enrolledAt: String?
    public let enrollmentStartedAt: String?
    public let introsCompleted: [Int]
    public let started: Bool
    public let startedAt: String?
    public let totalDays: Int?
    public var totalDaysCompleted: Int?
    public let totalIntros: Int?
    public var totalIntrosCompleted: Int?
    public var totalDaysMissed: Int?
    
}

// MARK: - JSON Key

public struct QuestUserProgressKey: Codable {
    
    public let userProgress: QuestUserProgress
    
}

// MARK: - Equatable

extension QuestUserProgress {
    
    public static func ==(lhs: QuestUserProgress, rhs: QuestUserProgress) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.currentDay != rhs.currentDay {
            return false
        }
        if lhs.currentDayId != rhs.currentDayId {
            return false
        }
        if lhs.daysCompleted != rhs.daysCompleted {
            return false
        }
        if lhs.ended != rhs.ended {
            return false
        }
        if lhs.endedAt != rhs.endedAt {
            return false
        }
        if lhs.completed != rhs.completed {
            return false
        }
        if lhs.completedAt != rhs.completedAt {
            return false
        }
        if lhs.enrolledAt != rhs.enrolledAt {
            return false
        }
        if lhs.enrollmentStartedAt != rhs.enrollmentStartedAt {
            return false
        }
        if lhs.introsCompleted != rhs.introsCompleted {
            return false
        }
        if lhs.started != rhs.started {
            return false
        }
        if lhs.startedAt != rhs.startedAt {
            return false
        }
        if lhs.totalDays != rhs.totalDays {
            return false
        }
        if lhs.totalDaysCompleted != rhs.totalDaysCompleted {
            return false
        }
        if lhs.totalIntros != rhs.totalIntros {
            return false
        }
        if lhs.totalIntrosCompleted != rhs.totalIntrosCompleted {
            return false
        }
        if lhs.totalDaysMissed != rhs.totalDaysMissed {
            return false
        }
        return true
    }
}
