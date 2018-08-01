//
//  QuestTaskCoverAsset.swift
//  AwesomeCore
//
//  Created by Emmanuel on 30/05/2018.
//

import Foundation

public class QuestTaskCoverAsset: Codable, Equatable {
    
    public let overmindId: String?
    public let name: String?
    public let status: String?
    public let thumbnailUrl: String?
    public let url: String?
    public let edgeUrl: String?
    public let duration: Float?
    
    init(overmindId: String,
         name: String?,
         status: String?,
         thumbnailUrl: String?,
         url: String?,
         edgeUrl: String?,
         duration: Float?) {
        self.overmindId = overmindId
        self.name = name
        self.status = status
        self.thumbnailUrl = thumbnailUrl
        self.url = url
        self.edgeUrl = edgeUrl
        self.duration = duration
    }
    
}

// MARK: - JSON Key

public struct QuestTasksCoverAsset: Codable {
    
    public let tasksCoverAssets: [QuestTaskCoverAsset]
    
}

// MARK: - Equatable

extension QuestTaskCoverAsset {
    public static func ==(lhs: QuestTaskCoverAsset, rhs: QuestTaskCoverAsset) -> Bool {
        if lhs.overmindId != rhs.overmindId {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if lhs.status != rhs.status {
            return false
        }
        if lhs.thumbnailUrl != rhs.thumbnailUrl {
            return false
        }
        if lhs.edgeUrl != rhs.edgeUrl {
            return false
        }
        if lhs.duration != rhs.duration {
            return false
        }
        return true
    }
}
