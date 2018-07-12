//
//  QuestCategory.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/2/17.
//

import Foundation

public struct QuestCategory: Codable, Equatable {
    
    public let id: String?
    public let name: String?
    public let questId: String? // FK to the CDQuest
    
    init(id: String?,
         name: String?,
         questId: String? = nil) {
        self.id = id
        self.name = name
        self.questId = questId
    }
    
}

// MARK: - JSON Key

public struct QuestCategories: Codable {
    
    public let categories: [QuestCategory]
    
}

// MARK: - Equatable

extension QuestCategory {
    public static func ==(lhs: QuestCategory, rhs: QuestCategory) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if lhs.questId != rhs.questId {
            return false
        }
        return true
    }
}
