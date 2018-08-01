//
//  AwesomeTrackingParams.swift
//  AwesomeTracking
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/06/18.
//

import Foundation

public enum AwesomeTrackingParams: String {

    // MARK: - Quest app
    
    case email
    case userID = "user_id"
    case questID = "quest_id"
    case platform
    case contentID = "content_id"
    case assetID = "asset_id"
    case timeElapsed = "time_elapsed"
    case timeOfDay = "time_of_day"
    case date
    case boolean
    case identifier
    case dayPosition = "day_position"
    case network
    case dayType = "type"
    case cartValue = "cart_value"
    case tribeId = "tribe_id"
    case ratingValue = "rating_value"
    case productId = "product_id"
    case sectionId = "section_id"
    case pagePosition = "page_position"
    case communityURL = "community_URL"
    case time
    case provider
    case currency
    case mediaSource = "media_source"
    
    // MARK: - Mindvalley app
    
    case courseID = "course_id"
    case chapterID = "chapter_id"
    case chapterPosition = "chapter_position"
    case url
    case selectedTopicsIds = "Selected Topics IDs"
    case chosenEpisode = "Chosen Episode ID"
    case suggestedEpisodes = "Suggested Episodes IDs"
    case userSkipped = "User Skipped"
    case loginType = "Login Type"
    case appsflyerLink = "appsflyer_link"
    case channelId = "channel_id"
    case serieId = "series_id"
    case episodeId = "episode_id"
    case timeWatched = "time_watched"
    case localisation
    case appId = "app_id"
    
}
