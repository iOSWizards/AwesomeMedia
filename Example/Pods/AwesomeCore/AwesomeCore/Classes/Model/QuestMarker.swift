//
//  QuestMarker.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/2/17.
//

import Foundation

public struct QuestMarker: Codable, Equatable {
    
    public let id: String?
    public let name: String?
    public let status: String?
    public let time: Double
    public let assetId: String? // FK to the CDAsset
    
    init(id: String?, name: String?, status: String?, time: Double, assetId: String? = nil) {
        self.id = id
        self.name = name
        self.status = status
        self.time = time
        self.assetId = assetId
    }
    
}

// MARK: - JSON Key

public struct QuestMarkers: Codable {
    
    public let markers: [QuestMarker]
    
}

// MARK: - Equatable

extension QuestMarker {
    public static func ==(lhs: QuestMarker, rhs: QuestMarker) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if lhs.status != rhs.status {
            return false
        }
        if lhs.time != rhs.time {
            return false
        }
        if lhs.assetId != rhs.assetId {
            return false
        }
        return true
    }
}
