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
    public let favourite: Bool?
    public let mediaAsset: QuestAsset?
    public let previewAsset: QuestAsset?
    public let publishedAt: String?
    public let slug: String?
    public let tags: [QuestTag]?
    public let title: String?
    public let type: String?
    public let author: QuestAuthor?
    public let settings: QuestMediaSettings?
    public let attendanceCount: Int?
    public let attending: Bool?
    public let averageRating: Float?
    public let totalDuration: Double?
    public let info: String?
    public let endedAt: String?
    public let startedAt: String?
    public let bannerAsset: QuestAsset?
    public let categories: [QuestCategory]?
    public let ratingsCount: Int?
    public let mediaContents: [QuestMediaContent]?
    public let channel: QuestChannel?
    public let tools: [QuestMediaContent]?
    public let lessons: [QuestMediaContent]?
    
    // Computed properties
    
    public var hasDate: Bool {
        return startedAt != nil
    }
    
    public var formattedDate: String {
        guard let date = startedAt?.date else {
            return ""
        }
        
        // returns rounded hour if minutes == 0
        let comps = Calendar.current.dateComponents([.minute], from: date)
        if comps.minute == 0 {
            return date.toString(format: "dd MMMM yyyy | ha").uppercased()
        }
        
        return date.toString(format: "dd MMMM yyyy | h:mma").uppercased()
    }
    
    public var isLive: Bool {
        guard let startedDate = startedAt?.date,
            let endedDate = endedAt?.date else {
                return false
        }
        
        return startedDate.compare(Date()) == .orderedDescending && endedDate.compare(Date()) == .orderedAscending
    }
    
    public var isFinished: Bool {
        guard let endedDate = endedAt?.date else {
            return false
        }
        
        return endedDate.compare(Date()) == .orderedAscending
    }
    
    public var isStarted: Bool {
        guard let startedDate = startedAt?.date else {
            return false
        }
        
        return startedDate.compare(Date()) == .orderedAscending
    }
    
}

// MARK: - JSON Key

public struct SingleQuestMediaDataKey: Codable {
    
    public let data: SingleQuestMediaKey
    
}

public struct SingleQuestMediaKey: Codable {
    
    public let media: QuestMedia
    
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
        if lhs.author != rhs.author {
            return false
        }
        if lhs.settings != rhs.settings {
            return false
        }
        if lhs.attendanceCount != rhs.attendanceCount {
            return false
        }
        if lhs.averageRating != rhs.averageRating {
            return false
        }
        if lhs.info != rhs.info {
            return false
        }
        if lhs.endedAt != rhs.endedAt {
            return false
        }
        if lhs.startedAt != rhs.startedAt {
            return false
        }
        if lhs.bannerAsset != rhs.bannerAsset {
            return false
        }
        if lhs.categories != rhs.categories {
            return false
        }
        if lhs.ratingsCount != rhs.ratingsCount {
            return false
        }
        if lhs.mediaContents != rhs.mediaContents {
            return false
        }
        if lhs.channel != rhs.channel {
            return false
        }
        if lhs.tools != rhs.tools {
            return false
        }
        if lhs.lessons != rhs.lessons {
            return false
        }
        if lhs.totalDuration != rhs.totalDuration {
            return false
        }
        
        return true
    }
    
}
