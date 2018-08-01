//
//  QuestCaptionAsset.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 6/6/18.
//

import Foundation

public struct QuestCaptionAsset: Codable, Equatable {
    
    public let id: String?
    public let isDefault: Bool?
    public let label: String?
    public let language: String?
    public let url: String?
    
    init(id: String?, isDefault: Bool?, label: String?, language: String?, url: String?) {
        self.id = id
        self.isDefault = isDefault
        self.label = label
        self.language = language
        self.url = url
    }
    
}

// MARK: - Coding keys

extension QuestCaptionAsset {
    private enum CodingKeys: String, CodingKey {
        case id
        case isDefault = "default"
        case label
        case language
        case url
    }
}

// MARK: - Equatable

extension QuestCaptionAsset {
    public static func ==(lhs: QuestCaptionAsset, rhs: QuestCaptionAsset) -> Bool {
        if lhs.id != rhs.id {
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
        if lhs.url != rhs.url {
            return false
        }
        return true
    }
}
