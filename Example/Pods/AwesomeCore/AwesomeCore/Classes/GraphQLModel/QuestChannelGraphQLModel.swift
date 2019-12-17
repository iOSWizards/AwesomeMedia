//
//  ChannelGraphQLModel.swift
//  AwesomeCore-iOS10.0
//
//  Created by Evandro Harrison Hoffmann on 7/22/18.
//

import Foundation

public struct QuestChannelGraphQLModel {
    
    // MARK: - Model Sections
    
    // Channel
    
    static let channelModel = "id description publishedAt slug title attendingMedia { \(mediaModel) } coverAsset { \(QuestGraphQLModel.assetImageModel) }"
    static let channelContentModel = "\(channelModel) series { \(serieModel) } authors { \(authorModel) }"
    static let channelSeriesContentModel = "\(channelModel) series { \(serieContentModel) }"
    
    // Series
    
    static let serieModel = "id publishedAt slug subtitle title coverAsset { \(QuestGraphQLModel.assetImageModel) }"
    static let serieContentModel = "\(serieModel) media { \(mediaModel) }  authors { \(authorModel) }"
    
    // Media
    
    static let mediaModel = "totalDuration averageRating currentRating featured favourite id publishedAt slug title type attendanceCount attending info endedAt startedAt tags { \(tagModel) } coverAsset { \(QuestGraphQLModel.assetImageModel) } author { \(authorModel) } settings { \(mediaSettingsModel) } description mediaAsset { \(QuestGraphQLModel.assetModel) } previewAsset { \(QuestGraphQLModel.assetModel) } "
    static let tagModel = "name"
    static let favouriteMediaModel = "favouriteMedia(authorId: %@) { \(mediaModel) }"
    static let latestMediaModel = "latestMedia(authorId: %@, limit: %d) { \(mediaModel) }"
    static let featuredMediaModel = "featuredMedia(authorId: %@, limit: %d) { \(mediaModel) }"
    static let channelMediaModel = "media(authorId: %@, sort: %@, type: %@){ \(mediaModel) }"
    static let authorModel = "avatarAsset { \(QuestGraphQLModel.assetImageModel) } description id name slug"
    static let mediaSettingsModel = "zoomWebinarId"
    
    // MARK: - Channel Query
    
    private static let channelsModel = "query { channels { \(channelModel) %@ } }"
    
    public static func queryChannels(withAuthorId authorId: String?, featuredMediaLimit: Int, latestMediaLimit: Int) -> [String: AnyObject] {
        
        var extra = ""
        if let authorId = authorId {
            extra.append(" \(String(format: favouriteMediaModel, arguments: [authorId]))")

            if featuredMediaLimit > 0 {
                extra.append(" \(String(format: featuredMediaModel, arguments: [authorId, featuredMediaLimit]))")
            }
            if latestMediaLimit > 0 {
                extra.append(" \(String(format: latestMediaModel, arguments: [authorId, latestMediaLimit]))")
            }
        }
        
        return ["query": String(format: channelModel, arguments: [extra]) as AnyObject]
    }
    
    // MARK: - Single Channel Query
    
    private static let singleChannelModel = "query { channel(id:%@) { \(channelContentModel) %@ } }"
    private static let singleChannelSeriesModel = "query { channel(id:%@) { \(channelSeriesContentModel) %@ } }"
    
    public static func querySingleChannelModel(withId id: String, authorId: String?, featuredMediaLimit: Int, latestMediaLimit: Int, seriesContent: Bool = false) -> [String: AnyObject] {
        
        var extra = ""
        if let authorId = authorId {
            extra.append(" \(String(format: favouriteMediaModel, arguments: [authorId]))")
            
            if featuredMediaLimit > 0 {
                extra.append(" \(String(format: featuredMediaModel, arguments: [authorId, featuredMediaLimit]))")
            }
            if latestMediaLimit > 0 {
                extra.append(" \(String(format: latestMediaModel, arguments: [authorId, latestMediaLimit]))")
            }
        }
        
        return ["query": String(format: seriesContent ? singleChannelSeriesModel : singleChannelModel, arguments: [id, extra]) as AnyObject]
    }
    
    // MARK: - Single Series Query
    
    private static let singleSeriesModel = "query { series(id:%@) { \(serieContentModel) } }"
    
    public static func querySingleSeriesModel(withId id: String) -> [String: AnyObject] {
        return ["query": String(format: singleSeriesModel, arguments: [id]) as AnyObject]
    }
    
    // MARK: - Single Media Query
    
    private static let singleMediaModel = "query { media(id:%@) { \(mediaModel) } }"
    
    public static func querySingleMediaModel(withId id: String) -> [String: AnyObject] {
        return ["query": String(format: singleMediaModel, arguments: [id]) as AnyObject]
    }
    
    // MARK: - Media Rating Mutation
    
    private static let mediaRatingModel = "mutation { rateMedia(mediaId:%@, rating:%.2f) { id } }"
    
    public static func mutationMediaRatingModel(withId id: String, rating: Double) -> [String: AnyObject] {
        return ["query": String(format: mediaRatingModel, arguments: [id, rating]) as AnyObject]
    }
    
    // MARK: - RSVP/Attend Media Mutation
    
    private static let attendMediaModel = "mutation { attendMedia(mediaId:%@) { id } }"
    private static let unattendMediaModel = "mutation { unattendMedia(mediaId:%@) { id } }"
    
    public static func mutationAttendMediaModel(withId id: String, attend: Bool) -> [String: AnyObject] {
        return ["query": String(format: attend ? attendMediaModel : unattendMediaModel, arguments: [id]) as AnyObject]
    }
    
    // MARK: - Favourite Media Mutation
    
    private static let setFavouriteMediaModel = "mutation { setMediaAsFavourite(mediaId:%@) { id } }"
    private static let unsetFavouriteMediaModel = "mutation { unsetMediaAsFavourite(mediaId:%@) { id } }"
    
    public static func mutationFavouriteMediaModel(withId id: String, favourite: Bool) -> [String: AnyObject] {
        return ["query": String(format: favourite ? setFavouriteMediaModel : unsetFavouriteMediaModel, arguments: [id]) as AnyObject]
    }
    
    
}
