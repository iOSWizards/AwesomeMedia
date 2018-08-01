//
//  QuestProductSettings.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 6/6/18.
//

import Foundation

public struct QuestProductSettings: Codable, Equatable {
    
    public let color: String?
    public let salesPageUrl: String?
    
}

// MARK: - JSON Key

public struct QuestProductSettingsKey: Codable {
    
    public let settings: QuestProductSettings
    
}

// MARK: - Equatable

extension QuestProductSettings {
    
    public static func ==(lhs: QuestProductSettings, rhs: QuestProductSettings) -> Bool {
        if lhs.color != rhs.color {
            return false
        }
        if lhs.salesPageUrl != rhs.salesPageUrl {
            return false
        }
        return true
    }
}
