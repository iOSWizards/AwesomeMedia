//
//  QuestMediaContent.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 15/05/19.
//

import Foundation

public struct QuestMediaContent: Codable {
    
    public let contentAsset: QuestAsset?
    public let coverAsset: QuestAsset?
    public let position: Int?
    public let title: String?
    public let type: String?
    
}

// MARK: - Equatable

extension QuestMediaContent: Equatable {
    
    public static func ==(lhs: QuestMediaContent, rhs: QuestMediaContent) -> Bool {
        if lhs.contentAsset != rhs.contentAsset {
            return false
        }
        if lhs.coverAsset != rhs.coverAsset {
            return false
        }
        if lhs.position != rhs.position {
            return false
        }
        if lhs.title != rhs.title {
            return false
        }
        if lhs.type != rhs.type {
            return false
        }
        
        return true
    }
}
