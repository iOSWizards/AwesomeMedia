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
    
    static let channelModel = "id description publishedAt slug title coverAsset { \(QuestGraphQLModel.assetImageModel) }"
    static let channelContentModel = "\(channelModel) series { \(serieModel) }"
    
    // Series
    
    static let serieModel = "id publishedAt slug subtitle title media { \(mediaModel) } coverAsset { \(QuestGraphQLModel.assetImageModel) }"
    
    // Media
    
    static let mediaModel = "averageRating currentRating description featured id publishedAt slug title type tags { \(tagModel) } coverAsset { \(QuestGraphQLModel.assetImageModel) } mediaAsset { \(QuestGraphQLModel.assetModel) } previewAsset { \(QuestGraphQLModel.assetModel) } "
    static let tagModel = "name"
    static let latestMediaModel = "latestMedia(limit: %d) { \(mediaModel) }"
    static let featuredMediaModel = "featuredMedia(limit: %d) { \(mediaModel) }"
    
    // MARK: - Channel Query
    
    private static let channelsModel = "query { channels { \(channelModel) %@ } }"
    
    public static func queryChannels(withFeaturedMediaLimit featuredMediaLimit: Int, latestMediaLimit: Int) -> [String: AnyObject] {
        
        var extra = ""
        if featuredMediaLimit > 0 {
            extra.append(" \(String(format: featuredMediaModel, arguments: [featuredMediaLimit]))")
        }
        if latestMediaLimit > 0 {
            extra.append(" \(String(format: latestMediaModel, arguments: [latestMediaLimit]))")
        }
        
        return ["query": String(format: channelModel, arguments: [extra]) as AnyObject]
    }
    
    // MARK: - Single Channel Query
    
    private static let singleChannelModel = "query { channel(id:%@) { \(channelContentModel) %@ } }"
    
    public static func querySingleChannelModel(withId id: String, featuredMediaLimit: Int, latestMediaLimit: Int) -> [String: AnyObject] {
        
        var extra = ""
        if featuredMediaLimit > 0 {
            extra.append(" \(String(format: featuredMediaModel, arguments: [featuredMediaLimit]))")
        }
        if latestMediaLimit > 0 {
            extra.append(" \(String(format: latestMediaModel, arguments: [latestMediaLimit]))")
        }
        
        return ["query": String(format: singleChannelModel, arguments: [id, extra]) as AnyObject]
    }
    
    
}
