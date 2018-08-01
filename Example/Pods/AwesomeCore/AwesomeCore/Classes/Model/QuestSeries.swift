//
//  SoulvanaSeries.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 7/23/18.
//

import Foundation

public struct QuestSeries : Codable, Equatable {
    
    public let id: String?
    public let coverAsset: QuestAsset?
    public let media: [QuestMedia]?
    public let featuredMedia: [QuestMedia]?
    public let latestMedia: [QuestMedia]?
    public let publishedAt: String?
    public let slug: String?
    public let subtitle: String?
    public let title: String?
    
}

// MARK: - Equatable

extension QuestSeries {
    
    static public func ==(lhs: QuestSeries, rhs: QuestSeries) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.coverAsset != rhs.coverAsset {
            return false
        }
        if lhs.title != rhs.title {
            return false
        }
        if lhs.subtitle != rhs.subtitle {
            return false
        }
        if lhs.publishedAt != rhs.publishedAt {
            return false
        }
        if lhs.slug != rhs.slug {
            return false
        }
        if lhs.media != rhs.media {
            return false
        }
        
        return true
    }
    
}
