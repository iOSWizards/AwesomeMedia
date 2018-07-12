//
//  QuestCaption.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 6/6/18.
//

import Foundation

public struct QuestCaption: Codable, Equatable {
    
    public let captionAsset: QuestAsset?
    public let isDefault: Bool?
    public let label: String?
    public let language: String?
    
    init(captionAsset: QuestAsset?, isDefault: Bool?, label: String?, language: String?) {
        self.captionAsset = captionAsset
        self.isDefault = isDefault
        self.label = label
        self.language = language
    }
    
}

// MARK: - Coding keys

extension QuestCaption {
    private enum CodingKeys: String, CodingKey {
        case captionAsset
        case isDefault = "default"
        case label
        case language
    }
}

// MARK: - JSON Key

public struct QuestCaptions: Codable {
    
    public let captions: [QuestCaption]
    
}

// MARK: - Equatable

extension QuestCaption {
    public static func ==(lhs: QuestCaption, rhs: QuestCaption) -> Bool {
        if lhs.captionAsset != rhs.captionAsset {
            return false
        }
        if lhs.isDefault != rhs.isDefault {
            return false
        }
        if lhs.label != rhs.label {
            return false
        }
        if lhs.language != rhs.language {
            return false
        }
        return true
    }
}
