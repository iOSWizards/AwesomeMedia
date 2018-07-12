//
//  QuestProductPage.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/7/17.
//

import Foundation

public struct QuestProductPage: Codable, Equatable {
    
    public let description: String?
    public let id: String?
    public let name: String?
    public let position: Int
    public let sections: [QuestSection]?
    public let productId: String?  // FK to the CDProduct
    
    public init(description: String?,
         id: String?,
         name: String?,
         position: Int,
         sections: [QuestSection]?,
         productId: String? = nil) {
        self.description = description
        self.id = id
        self.name = name
        self.position = position
        self.sections = sections
        self.productId = productId
    }
    
}

// MARK: - JSON Key

public struct QuestProductPages: Codable {
    
    public let pages: [QuestProductPage]
    
}

// MARK: - Equatable

extension QuestProductPage {
    public static func ==(lhs: QuestProductPage, rhs: QuestProductPage) -> Bool {
        if lhs.description != rhs.description {
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
        if lhs.productId != rhs.productId {
            return false
        }
        return true
    }
}
