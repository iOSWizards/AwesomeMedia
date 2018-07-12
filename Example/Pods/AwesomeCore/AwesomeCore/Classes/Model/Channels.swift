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
