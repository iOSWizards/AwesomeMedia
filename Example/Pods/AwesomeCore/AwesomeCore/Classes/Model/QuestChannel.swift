//
//  SoulvanaChannel.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 7/23/18.
//

import Foundation

public struct QuestChannel : Codable, Equatable {
    
    public let id: String?
    public let coverAsset: QuestAsset?
    public let description: String?
    public let publishedAt: String?
    public let series: [QuestSeries]?
    public let featuredMedia: [QuestMedia]?
    public let latestMedia: [QuestMedia]?
    public let slug: String?
    public let title: String?
    
}

// MARK: - JSON Key

public struct QuestChannelsDataKey: Codable {
    
    public let data: QuestChannelssKey
    
}

public struct QuestChannelssKey: Codable {
    
    public let channels: [QuestChannel]
    
}

public struct SingleQuestChannelDataKey: Codable {
    
    public let data: SingleQuestChannelKey
    
}

public struct SingleQuestChannelKey: Codable {
    
    public let channel: QuestChannel
    
}
// MARK: - Equatable

extension QuestChannel {
    
    static public func ==(lhs: QuestChannel, rhs: QuestChannel) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.coverAsset != rhs.coverAsset {
            return false
        }
        if lhs.description != rhs.description {
            return false
        }
        if lhs.publishedAt != rhs.publishedAt {
            return false
        }
        if lhs.series != rhs.series {
            return false
        }
        if lhs.slug != rhs.slug {
            return false
        }
        if lhs.title != rhs.title {
            return false
        }
        if lhs.featuredMedia != rhs.featuredMedia {
            return false
        }
        if lhs.latestMedia != rhs.latestMedia {
            return false
        }
        
        return true
    }
    
}
