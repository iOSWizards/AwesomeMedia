//
//  Series.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/05/18.
//

import Foundation

public struct Series: Codable {
    public let serie: SeriesData
}

public struct SeriesData: Codable {
    
    public let id: String
    public let title: String
    public let slug: String
    public let channelId: String
    public let coverImage: String
    public let featuredEpisode: ChannelEpisode
    public let episodes: [ChannelEpisode]
    
}

// MARK: - Coding keys

extension Series {
    private enum CodingKeys: String, CodingKey {
        case serie = "series"
    }
}

extension SeriesData {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case slug
        case channelId = "channel_id"
        case coverImage = "image"
        case featuredEpisode = "featured_episode"
        case episodes
    }
}

// MARK: - Equatable

extension Series {
    public static func ==(lhs: Series, rhs: Series) -> Bool {
        if lhs.serie.title != rhs.serie.title  {
            return false
        }
        return true
    }
}
