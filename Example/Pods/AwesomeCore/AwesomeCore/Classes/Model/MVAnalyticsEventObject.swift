//
//  MVAnalyticsEventObject.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/10/18.
//

import Foundation

public struct MVAnalyticsEventObject: Codable {
    
    public var objectType: String
    public var title: String
    public var categoryId: String?
    public var categoryName: String?
    public var answerId: String?
    public var day: String?
    public var assetId: String?
    public var type: String?
    public var questName: String?
    public var questId: String?
    public var cohortId: String?
    public var cohortName: String?
    public var episodeId: String?
    public var dayPosition: String?
    public var channelId: String?
    public var courseName: String?
    public var academyId: String?
    public var screen: String?
    public var courseId: String?
    public var mediaId: String?
    public var mediaType: String?
    public var mediaName: String?
    public var channelName: String?
    public var seriesId: String?
    public var seriesName: String?
    public var mediaContentTitle: String?
    public var part: String?
    public var view: String?
    public var category: String?
    public var categoryLocation: String?
    public var communityName: String?
    public var communityId: String?
    
    public init(objectType: String,
                title: String) {
        
        self.objectType = objectType
        self.title = title
        
    }
    
}

extension MVAnalyticsEventObject {
    
    // MARK: - Coding keys
    
    private enum CodingKeys: String, CodingKey {
        case objectType = "object_type"
        case title
        case categoryId = "category_id"
        case categoryName = "category_name"
        case answerId = "answer_id"
        case day
        case assetId = "asset_id"
        case type
        case questName = "quest_name"
        case questId = "quest_id"
        case cohortId = "cohort_id"
        case cohortName = "cohort_name"
        case episodeId = "episode_id"
        case dayPosition = "day_position"
        case channelId = "channel_id"
        case courseName = "course_name"
        case academyId = "academy_id"
        case screen
        case courseId = "course_id"
        case mediaId = "media_id"
        case mediaType = "media_type"
        case mediaName = "media_name"
        case channelName = "channel_name"
        case seriesId = "series_id"
        case seriesName = "series_name"
        case mediaContentTitle = "media_content_title"
        case part
        case view
        case category
        case categoryLocation = "category_location"
        case communityName = "community_name"
        case communityId = "community_id"
    }
    
}
