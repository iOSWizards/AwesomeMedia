//
//  QuestSection.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/3/17.
//

import Foundation

public struct QuestSection: Codable, Equatable {
    
    public let coverAsset: QuestAsset?
    public let duration: Double?
    public let id: String?
    public let info: QuestSectionInfo?
    public let position: Int?
    public var primaryAsset: QuestAsset?
    public let type: String?
    public let pageId: String?        // FK to the CDPage
    public let productPageId: String? // FK to the CDProductPage
    
    public init(coverAsset: QuestAsset?,
         duration: Double?,
         id: String?,
         info: QuestSectionInfo?,
         position: Int?,
         primaryAsset: QuestAsset?,
         type: String?,
         pageId: String? = nil,
         productPageId: String? = nil) {
        self.coverAsset = coverAsset
        self.duration = duration
        self.id = id
        self.info = info
        self.position = position
        self.primaryAsset = primaryAsset
        self.type = type
        self.pageId = pageId
        self.productPageId = productPageId
    }

    // MARK: - Type information
    
    public var sectionType: QuestSectionType {
        guard let type = type else {
            return .text
        }
        
        return QuestSectionType(rawValue: type) ?? .text
    }
}

// MARK: - Content Section Types

public enum QuestSectionType: String {
    case video
    case audio
    case text
    case file
    case image
    case enroll
}

// MARK: - JSON Key

public struct QuestSections: Codable {
    
    public let sections: [QuestSection]
    
}

// MARK: - Equatable

extension QuestSection {
    public static func ==(lhs: QuestSection, rhs: QuestSection) -> Bool {
        if lhs.coverAsset != rhs.coverAsset {
            return false
        }
        if lhs.duration != rhs.duration {
            return false
        }
        if lhs.id != rhs.id {
            return false
        }
        if lhs.info != rhs.info {
            return false
        }
        if lhs.position != rhs.position {
            return false
        }
        if lhs.primaryAsset != rhs.primaryAsset {
            return false
        }
        if lhs.type != rhs.type {
            return false
        }
        if lhs.pageId != rhs.pageId {
            return false
        }
        if lhs.productPageId != rhs.productPageId {
            return false
        }
        return true
    }
}
