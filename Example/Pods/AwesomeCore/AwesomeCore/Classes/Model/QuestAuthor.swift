//
//  QuestAuthor.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/2/17.
//

import Foundation

public struct QuestAuthor: Codable, Equatable {
    
    public let avatarAsset: QuestAsset?
    public let portraitAsset: QuestAsset?
    public let description: String?
    public let id: String?
    public let name: String?
    public let slug: String?
    public let questId: String? // FK to the CDQuest
    
    init(avatarAsset: QuestAsset?, portraitAsset: QuestAsset?, description: String?, id: String?, name: String?,
         slug: String?, questId: String? = nil) {
        self.avatarAsset = avatarAsset
        self.portraitAsset = portraitAsset
        self.description = description
        self.id = id
        self.name = name
        self.slug = slug
        self.questId = questId
    }
    
}

// MARK: - JSON Key

public struct QuestAuthors: Codable {
    
    public let authors: [QuestAuthor]
    
}

// MARK: - Equatable

extension QuestAuthor {
    public static func ==(lhs: QuestAuthor, rhs: QuestAuthor) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.avatarAsset != rhs.avatarAsset {
            return false
        }
        if lhs.portraitAsset != rhs.portraitAsset {
            return false
        }
        if lhs.description != rhs.description {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if lhs.slug != rhs.slug {
            return false
        }
        if lhs.questId != rhs.questId {
            return false
        }
        return true
    }
}
