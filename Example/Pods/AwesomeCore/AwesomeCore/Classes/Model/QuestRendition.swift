//
//  QuestRendition.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/2/17.
//

import Foundation

public struct QuestRendition: Codable, Equatable {
    
    public let contentType: String?
    public let duration: Double?
    public let edgeUrl: String?
    public let filesize: Int?
    public let id: String?
    public let name: String?
    public let overmindId: String?
    public let secure: Bool?
    public let status: String?
    public let thumbnailUrl: String?
    public let url: String?
    public let assetId: String? // FK to the CDAsset
    
    init(contentType: String?, duration: Double?, edgeUrl: String?, filesize: Int?,
         id: String?, name: String?, overmindId: String?, secure: Bool?, status: String?,
         thumbnailUrl: String?, url: String?, assetId: String? = nil) {
        self.contentType = contentType
        self.duration = duration
        self.edgeUrl = edgeUrl
        self.filesize = filesize
        self.id = id
        self.name = name
        self.overmindId = overmindId
        self.secure = secure
        self.status = status
        self.thumbnailUrl = thumbnailUrl
        self.url = url
        self.assetId = assetId
    }
}

// MARK: - JSON Key

public struct QuestRenditions: Codable {
    
    public let renditions: [QuestRendition]
    
}

// MARK: - Equatable

extension QuestRendition {
    public static func ==(lhs: QuestRendition, rhs: QuestRendition) -> Bool {
        if lhs.contentType != rhs.contentType {
            return false
        }
        if lhs.duration != rhs.duration {
            return false
        }
        if lhs.edgeUrl != rhs.edgeUrl {
            return false
        }
        if lhs.filesize != rhs.filesize {
            return false
        }
        if lhs.id != rhs.id {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if lhs.overmindId != rhs.overmindId {
            return false
        }
        if lhs.secure != rhs.secure {
            return false
        }
        if lhs.status != rhs.status {
            return false
        }
        if lhs.thumbnailUrl != rhs.thumbnailUrl {
            return false
        }
        if lhs.url != rhs.url {
            return false
        }
        if lhs.assetId != rhs.assetId {
            return false
        }
        return true
    }
}
