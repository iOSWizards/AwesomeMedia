//
//  QuestSectionInfo.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/3/17.
//

import Foundation

public struct QuestSectionInfo: Codable, Equatable {
    
    public let body: String?
    public let caption: String?
    public let downloadable: Bool?
    public let externalLink: String?
    public let id: String?
    public let link: String?
    public let mode: String?
    public let title: String?
    public let sectionId: String? // FK to the CDSession
    
    enum CodingKeys: String, CodingKey {
        case body
        case caption
        case downloadable
        case externalLink
        case id
        case link
        case mode
        case title
    }
    
    init(
        body: String?,
        caption: String?,
        downloadable: Bool?,
        externalLink: String?,
        id: String?,
        link: String?,
        mode: String?,
        title:String?,
        sectionId: String? = nil) {
        self.body = body
        self.caption = caption
        self.downloadable = downloadable
        self.externalLink = externalLink
        self.id = id
        self.link = link
        self.mode = mode
        self.title = title
        self.sectionId = sectionId
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        body = try values.decodeIfPresent(String.self, forKey: .body) ?? nil
        caption = try values.decodeIfPresent(String.self, forKey: .caption) ?? nil
        externalLink = try values.decodeIfPresent(String.self, forKey: .externalLink) ?? nil
        id = try values.decodeIfPresent(String.self, forKey: .id) ?? nil
        link = try values.decodeIfPresent(String.self, forKey: .link) ?? nil
        mode = try values.decodeIfPresent(String.self, forKey: .mode) ?? nil
        title = try values.decodeIfPresent(String.self, forKey: .title) ?? nil
        sectionId = nil
        
        if let stringValue = try values.decodeIfPresent(String.self, forKey: .downloadable) ?? nil {
            downloadable = Bool(stringValue)
        } else {
            downloadable = false
        }
    }
    
}

extension QuestSectionInfo {
    public static func ==(lhs: QuestSectionInfo, rhs: QuestSectionInfo) -> Bool {
        if lhs.body != rhs.body {
            return false
        }
        if lhs.caption != rhs.caption {
            return false
        }
        if lhs.downloadable != rhs.downloadable {
            return false
        }
        if lhs.externalLink != rhs.externalLink {
            return false
        }
        if lhs.id != rhs.id {
            return false
        }
        if lhs.link != rhs.link {
            return false
        }
        if lhs.mode != rhs.mode {
            return false
        }
        if lhs.title != rhs.title {
            return false
        }
        if lhs.sectionId != rhs.sectionId {
            return false
        }
        return true
    }
}

// MARK: - JSON Key

public struct QuestSectionInfoKey: Codable {
    
    public let info: QuestSectionInfo
    
}

extension KeyedDecodingContainer {
    func decodeWrapper<T>(key: K, defaultValue: T) throws -> T where T : Decodable {
        return try decodeIfPresent(T.self, forKey: key) ?? defaultValue
    }
}
