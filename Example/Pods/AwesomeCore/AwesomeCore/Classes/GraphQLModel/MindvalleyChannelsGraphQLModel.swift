//
//  MindvalleyChannelsGraphQLModel.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 16/05/19.
//

import Foundation

public struct MindvalleyChannelsGraphQLModel {
    
    // MARK: - Model Sections
    
    // Channel
    
    static let channelModel = "id title slug publishedMediaCount mediaCount coverAsset { \(QuestGraphQLModel.assetImageModel) } iconAsset { \(QuestGraphQLModel.assetImageModel) }"
    static let channelSeriesModel = "series(sort: \"%@\") { \(serieModel) }"
    static let channelContentModel = "\(channelModel) series { \(serieModel) } authors { \(authorModel) }"
    static let channelSeriesContentModel = "\(channelModel) series { \(serieContentModel) }"
    static let channelEpisodeModel = "id title"
    
    // Series
    
    static let serieModel = "id title coverAsset { \(QuestGraphQLModel.assetImageModel) }"
    static let serieContentModel = "\(serieModel) media { \(mediaModel) }  authors { \(authorModel) }"
    
    // Media
    
    static let mediaModel = "id totalDuration title type description coverAsset { \(QuestGraphQLModel.assetImageModel) } author { \(authorModel) } lessons: mediaContents(group:\"lesson\") { \(mediaContentsModel) } tools: mediaContents(group:\"material\") { \(mediaContentsModel) } mediaAsset { \(QuestGraphQLModel.assetModel) }"
    
    static let mediaLiteModel = "id totalDuration title type coverAsset { \(QuestGraphQLModel.assetImageModel) }"
    
    static let tagModel = "name"
    static let favouriteMediaModel = "favouriteMedia(authorId: %@) { \(mediaLiteModel) }"
    static let latestMediaModel = "latestMedia(limit: %d) { \(mediaLiteModel) }"
    static let featuredMediaModel = "featuredMedia(limit: %d) { \(mediaLiteModel) }"
    static let channelMediaModel = "media(authorId: %@, sort: %@, type: %@){ \(mediaModel) }"
    static let authorModel = "avatarAsset { \(QuestGraphQLModel.assetImageModel) } description id name slug"
    static let mediaSettingsModel = "zoomWebinarId"
    static let mediaCategoriesModel = "id name"
    static let mediaContentsModel = "contentAsset { \(QuestGraphQLModel.assetModel) } coverAsset { \(QuestGraphQLModel.assetImageModel) } position title type"
    
    // MARK: - Channel Query
    
    private static let channelsModel = "query { channels { \(channelModel) %@ } }"
    
    public static func queryChannels(withAuthorId authorId: String?, featuredMediaLimit: Int, latestMediaLimit: Int, sortSeriesBy: String?) -> [String: AnyObject] {
        
        var extra = ""
        
        if let sort = sortSeriesBy {
            extra.append(" \(String(format: channelSeriesModel, arguments: [sort]))")
        }
        
        if let authorId = authorId {
            extra.append(" \(String(format: favouriteMediaModel, arguments: [authorId]))")
            
            if featuredMediaLimit > 0 {
                extra.append(" \(String(format: featuredMediaModel, arguments: [authorId, featuredMediaLimit]))")
            }
            
            if latestMediaLimit > 0 {
                extra.append(" \(String(format: latestMediaModel, arguments: [authorId, latestMediaLimit]))")
            }
            
        } else {
            if latestMediaLimit > 0 {
                extra.append(" \(String(format: latestMediaModel, arguments: [latestMediaLimit]))")
            }
            
            if featuredMediaLimit > 0 {
                extra.append(" \(String(format: featuredMediaModel, arguments: [featuredMediaLimit]))")
            }
        }
        
        return ["query": String(format: channelsModel, arguments: [extra]) as AnyObject]
    }
    
    // MARK: - Single Channel Query
    
    private static let singleChannelModel = "query { channel(id:%@) { \(channelModel) %@ } }"
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
        } else {
            if featuredMediaLimit > 0 {
                extra.append(" \(String(format: featuredMediaModel, arguments: [featuredMediaLimit]))")
            }
            if latestMediaLimit > 0 {
                extra.append(" \(String(format: latestMediaModel, arguments: [latestMediaLimit]))")
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
    
    // MARK: - Single Media Query
    private static let mediaListModel = "id title slug type totalDuration channel { \(channelEpisodeModel) } mediaAsset { \(QuestGraphQLModel.assetModel) } coverAsset { \(QuestGraphQLModel.assetImageModel)}"
    private static let mediaListQueryModel = "{ mediaList(sort:\"%@\", pageSize:%@, page:%@) { \(mediaListModel) } }"
    private static let mediaListQueryModelCategories = "{ mediaList(sort:\"%@\", pageSize:%@, categoryId:%@, page:%@) { \(mediaListModel) } }"
    private static let mediaListQueryModelChannels = "{ mediaList(sort:\"%@\", pageSize:%@, channelId:%@, page:%@) { \(mediaListModel) } }"
    private static let mediaListQueryModelCategoriesChannels = "{ mediaList(sort:\"%@\", pageSize:%@, categoryId:%@, channelId:%@, page:%@) { \(mediaListModel) } }"
    private static let mediaListQueryModelSeries = "{ mediaList(sort:\"%@\", seriesId:%@, status:\"%@\") { \(mediaListModel) } }"
    
    public static func queryMediaListModel(sort: String, limit: Int, page: Int, categoryId: String?, channelId: String?, seriesId: Int?, status: String) -> [String: AnyObject] {
        if let categoryId = categoryId {
            if let channelId = channelId {
                return ["query": String(format: mediaListQueryModelCategoriesChannels, arguments: [sort, String(limit), categoryId, channelId, String(page)]) as AnyObject]
            } else {
                return ["query": String(format: mediaListQueryModelCategories, arguments: [sort, String(limit), categoryId, String(page)]) as AnyObject]
            }
        } else {
            if let channelId = channelId {
                return ["query": String(format: mediaListQueryModelChannels, arguments: [sort, String(limit), channelId, String(page)]) as AnyObject]
            } else {
                if let seriesId = seriesId {
                    return ["query": String(format: mediaListQueryModelSeries, arguments: [sort, String(seriesId), status]) as AnyObject]
                }
                return ["query": String(format: mediaListQueryModel, arguments: [sort, String(limit), String(page)]) as AnyObject]
            }
        }
    }
    
}

