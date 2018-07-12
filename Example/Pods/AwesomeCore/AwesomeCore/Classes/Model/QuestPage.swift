//
//  QuestPage.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/2/17.
//

import Foundation

public class QuestPage: Codable, Equatable {
    
    public let completionsCount: Int?
    public let date: String?
    public let description: String?
    public let duration: Double?
    public let groupName: String?
    public let id: String?
    public let name: String?
    public let position: Int
    public let sections: [QuestSection]?
    public var tasks: [QuestTask]?
    public let type: String?
    public let url: String?
    public var completed: Bool?
    public let questId: String? // FK to the CDQuest
    
    init(completionsCount: Int?,
         date: String?,
         description: String?,
         duration: Double?,
         groupName: String?,
         id: String?,
         name: String?,
         position: Int,
         sections: [QuestSection]?,
         tasks: [QuestTask]?,
         type: String?,
         url: String?,
         completed: Bool?,
         questId: String? = nil) {
        self.completionsCount = completionsCount
        self.date = date
        self.description = description
        self.duration = duration
        self.groupName = groupName
        self.id = id
        self.name = name
        self.position = position
        self.sections = sections
        self.tasks = tasks
        self.type = type
        self.url = url
        self.completed = completed
        self.questId = questId
    }
    
    // MARK: - Computed properties
    
    public var dayPosition: String {
        return "\(self.position)"
    }
    
    public var dayTitle: String {
        return "\(dayType) \(self.position)"
    }
    
    public var dayTitleFull: String {
        return "\(dayType) \(self.position) - \(self.name ?? "")"
    }
    
    public var dayType: String {
        return self.type == QuestContentType.warmup.rawValue ? "Part".localized : "Day".localized
    }
    
    public var durationString: String {
        return (duration ?? 0).timeString
    }
    
    public func isCurrentPage(quest: Quest?, compareToDate: Date = Date()) -> Bool {
        //if is warmup, means it's never current day
        if self.type == QuestContentType.warmup.rawValue {
            return false
        }
        
        guard let quest = quest else {
            return false
        }
        
        if let currentDay = quest.userProgress?.currentDay {
            return self.position == currentDay.position
        }
        
        return compareToDate == date?.date
    }
    
    public func isFuturePage(quest: Quest?) -> Bool {
        //if is warmup, means it's never current day
        if self.type == QuestContentType.warmup.rawValue {
            return false
        }
        
        guard let quest = quest else {
            return false
        }
        
        if let currentDay = quest.userProgress?.currentDay {
            return self.position > currentDay.position
        }
        
        return true
    }
    
    public func isLastDay(quest: Quest?) -> Bool {
        if self.type == QuestContentType.warmup.rawValue {
            return false
        }
        
        guard let quest = quest else {
            return false
        }
        
        if let currentDay = quest.userProgress?.currentDay {
            return (self.position == currentDay.position && !isFuturePage(quest: quest)) ? true : false
        }
        
        return false
    }

    public var isCompleted: Bool {
        return completed ?? false
    }
    
    public var canCompleteDay: Bool {
        guard let tasks = tasks else {
            return true
        }
        
        if tasks.count > 0 {
            var completedCount = 0
            for task in tasks {
                if task.completed || !task.required {
                    completedCount += 1
                }
            }
            
            return completedCount == tasks.count
        }
        
        return true
    }

}

// MARK: - JSON Key

public struct QuestPages: Codable {
    
    public let pages: [QuestPage]
    
}

public struct SingleQuestPageDataKey: Codable {
    
    public let data: SingleQuestPageKey
    
}

public struct SingleQuestPageKey: Codable {
    
    public let page: QuestPage
    
}

// MARK: - Equatable

extension QuestPage {
    public static func ==(lhs: QuestPage, rhs: QuestPage) -> Bool {
        if lhs.completionsCount != rhs.completionsCount {
            return false
        }
        if lhs.date != rhs.date {
            return false
        }
        if lhs.description != rhs.description {
            return false
        }
        if lhs.duration != rhs.duration {
            return false
        }
        if lhs.groupName != rhs.groupName {
            return false
        }
        if lhs.id != rhs.id {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if lhs.position != rhs.position {
            return false
        }
        if !Utility.equals(lhs.sections, rhs.sections) {
            return false
        }
        if !Utility.equals(lhs.tasks, rhs.tasks) {
            return false
        }
        if lhs.type != rhs.type {
            return false
        }
        if lhs.url != rhs.url {
            return false
        }
        if lhs.questId != rhs.questId {
            return false
        }
        if lhs.completed != rhs.completed {
            return false
        }
        return true
    }
    
}

