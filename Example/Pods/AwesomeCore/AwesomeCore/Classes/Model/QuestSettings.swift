//
//  QuestSettings.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/2/17.
//

import Foundation

public struct QuestSettings: Codable, Equatable {
    
    public let awcProductId: String?
    public let facebookGroupImageUrl: String?
    public let facebookGroupPassPhrase: String?
    public let facebookGroupUrl: String?
    public let facebookGroupId: String?
    public let perpetual: Bool
    public let salesUrl: String?
    public let shareImageUrl: String?
    public let studentsCount: Int?
    public let questId: String? // FK to the CDQuest
    
    init(awcProductId: String?,
         facebookGroupImageUrl: String?,
         facebookGroupPassPhrase: String?,
         facebookGroupUrl: String?,
         facebookGroupId: String?,
         perpetual: Bool,
         salesUrl: String?,
         shareImageUrl: String?,
         studentsCount: Int?,
         questId: String? = nil) {
        self.awcProductId = awcProductId
        self.facebookGroupImageUrl = facebookGroupImageUrl
        self.facebookGroupPassPhrase = facebookGroupPassPhrase
        self.facebookGroupUrl = facebookGroupUrl
        self.facebookGroupId = facebookGroupId
        self.perpetual = perpetual
        self.salesUrl = salesUrl
        self.shareImageUrl = shareImageUrl
        self.studentsCount = studentsCount
        self.questId = questId
    }
    
}

// MARK: - JSON Key

public struct QuestSettingsKey: Codable {
    
    public let settings: QuestSettings
    
}

// MARK: - Equatable

extension QuestSettings {
    public static func ==(lhs: QuestSettings, rhs: QuestSettings) -> Bool {
        if lhs.awcProductId != rhs.awcProductId {
            return false
        }
        if lhs.facebookGroupImageUrl != rhs.facebookGroupImageUrl {
            return false
        }
        if lhs.facebookGroupPassPhrase != rhs.facebookGroupPassPhrase {
            return false
        }
        if lhs.facebookGroupUrl != rhs.facebookGroupUrl {
            return false
        }
        if lhs.facebookGroupId != rhs.facebookGroupId {
            return false
        }
        if lhs.perpetual != rhs.perpetual {
            return false
        }
        if lhs.salesUrl != rhs.salesUrl {
            return false
        }
        if lhs.shareImageUrl != rhs.shareImageUrl {
            return false
        }
        if lhs.studentsCount != rhs.studentsCount {
            return false
        }
        if lhs.questId != rhs.questId {
            return false
        }
        return true
    }
}
