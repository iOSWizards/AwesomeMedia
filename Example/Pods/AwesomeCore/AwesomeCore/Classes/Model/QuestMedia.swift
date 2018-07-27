//
//  SoulvanaMedia.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 7/23/18.
//

import Foundation

public struct QuestMedia : Codable, Equatable {
    
    public let id: String?
    public let coverAsset: QuestAsset?
    public let currentRating: Float?
    public let description: String?
    public let featured: Bool?
    public let mediaAsset: QuestAsset?
    public let previewAsset: QuestAsset?
    public let publishedAt: String?
    public let slug: String?
    public let tags: [QuestTag]?
    public let title: String?
    public let type: String?
    
}

// MARK: - Equatable

extension QuestMedia {
    
    static public func ==(lhs: QuestMedia, rhs: QuestMedia) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.coverAsset != rhs.coverAsset {
            return false
        }
        if lhs.title != rhs.title {
            return false
        }
        if lhs.currentRating != rhs.currentRating {
            return false
        }
        if lhs.publishedAt != rhs.publishedAt {
            return false
        }
        if lhs.slug != rhs.slug {
            return false
        }
        if lhs.description != rhs.description {
            return false
        }
        if lhs.featured != rhs.featured {
            return false
        }
        if lhs.mediaAsset != rhs.mediaAsset {
            return false
        }
        if lhs.previewAsset != rhs.previewAsset {
            return false
        }
        if lhs.tags != rhs.tags {
            return false
        }
        if lhs.type != rhs.type {
            return false
        }
        
        return true
    }
    
}
