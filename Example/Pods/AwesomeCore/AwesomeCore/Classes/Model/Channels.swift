//
//  Channels.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 15/05/18.
//

import Foundation

public struct AllChannels: Codable {
    public let id: String
    public let slug: String
    public let title: String
    public let image: String
    
    public init(id: String, title: String, image: String) {
        self.id = id
        self.slug = ""
        self.title = title
        self.image = image
    }
}

public struct AllChannelsKey: Codable {
    public let channels: [AllChannels]
}

public struct Channels: Codable {
    public let channel: ChannelData
}

public struct ChannelData: Codable {
    
    public let id: String
    public let title: String
    public let imageUrl: String
    public let latestEpisodes: [ChannelEpisode]
    public let series: [ChannelSerie]
    
}

public enum ChannelEpisodeVideoRenditionType: String {
    case hls
    case mp4
    case webm
    case videoposter1
    case videoposter2
    case videoposter3
}

public struct ChannelEpisode: Codable {
    public let id: String
    public let title: String
    public let duration: Int
    public let assetCoverUrl: String
    public let assetUrl: String?
    public let assetExtension: String?
    public let type: String
    public let publishedAt: String
    public let serie: ChannelSerie?
    public let renditions: [QuestRendition]?
}

// MARK: - Renditions of ChannelEpisode

extension ChannelEpisode {
    public func videoUrl(withType type: QuestAssetVideoRenditionType = .hls) -> String? {
        guard let renditions = renditions, renditions.count > 0 else {
            return assetUrl
        }
        
        let streamingRendition = videoRendition(withType: type)
        
        if streamingRendition?.status == "error" {
            return videoRendition(withType: .mp4)?.url
        }
        
        return streamingRendition?.url
    }

    public func videoRendition(withType type: QuestAssetVideoRenditionType) -> QuestRendition? {
        
        guard let renditions = renditions, renditions.count > 0 else {
            return nil
        }
        
        for rendition in renditions where rendition.id == type.rawValue {
            return rendition
        }
        
        return nil
    }
}

public struct ChannelSerie: Codable {
    public let id: String
    public let title: String
    public let slug: String
    public let channelId: String
    public let coverImageUrl: String
}

public struct SeriesContent: Codable {
    public let name: String
    public let thumbnail: String
    public let academyId: String
    public let courseId: String
}

// MARK: - Coding keys

extension ChannelData {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case imageUrl = "image"
        case latestEpisodes
        case series
    }
}

extension ChannelEpisode {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case duration
        case assetCoverUrl = "image"
        case assetUrl = "asset_url"
        case assetExtension = "asset_file_extension"
        case type
        case publishedAt = "published_at"
        case serie = "series"
        case renditions
    }
}

extension ChannelSerie {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case slug
        case channelId = "channel_id"
        case coverImageUrl = "image"
    }
}

extension SeriesContent {
    private enum CodingKeys: String, CodingKey {
        case name
        case thumbnail
        case academyId = "academy_id"
        case courseId = "course_id"
    }
}

// MARK: - Equatable

extension Channels {
    public static func ==(lhs: Channels, rhs: Channels) -> Bool {
        if lhs.channel.id != rhs.channel.id  {
            return false
        }
        return true
    }
}
