//
//  QuestTask.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/3/17.
//

import Foundation

public class QuestTask: Codable, Equatable {
    
    public var completed: Bool
    public let completionDetails: String?
    public let description: String?
    public let id: String?
    public let imageUrl: String?
    public let coverAsset: QuestTaskCoverAsset?
    public let name: String?
    public let position: Int
    public let required: Bool
    public let type: String?
    public let pageId: String? // FK to the CDPage
    
    init(completed: Bool,
         completionDetails: String?,
         description: String?,
         id: String?,
         imageUrl: String?,
         coverAsset: QuestTaskCoverAsset?,
         name: String?,
         position: Int,
         required: Bool,
         type: String?,
         pageId: String? = nil) {
        self.completed = completed
        self.completionDetails = completionDetails
        self.description = description
        self.id = id
        self.imageUrl = imageUrl
        self.coverAsset = coverAsset
        self.name = name
        self.position = position
        self.required = required
        self.type = type
        self.pageId = pageId
    }
    
}

// MARK: - JSON Key

public struct QuestTasks: Codable {
    
    public let tasks: [QuestTask]
    
}

// MARK: - Equatable

extension QuestTask {
    public static func ==(lhs: QuestTask, rhs: QuestTask) -> Bool {
        if lhs.completed != rhs.completed {
            return false
        }
        if lhs.completionDetails != rhs.completionDetails {
            return false
        }
        if lhs.description != rhs.description {
            return false
        }
        if lhs.id != rhs.id {
            return false
        }
        if lhs.imageUrl != rhs.imageUrl {
            return false
        }
        if lhs.coverAsset != rhs.coverAsset {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if lhs.position != rhs.position {
            return false
        }
        if lhs.required != rhs.required {
            return false
        }
        if lhs.type != rhs.type {
            return false
        }
        if lhs.pageId != rhs.pageId {
            return false
        }
        return true
    }
}
