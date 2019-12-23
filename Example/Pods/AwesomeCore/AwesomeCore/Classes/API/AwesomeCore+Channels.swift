//
//  AppDelegate+Channels.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 7/23/18.
//

import Foundation
import RealmSwift

public extension AwesomeCore {
    
    // MARK: - Channels
    
    static func fetchChannels(withAuthorId authorId: String? = nil,params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int = 0, latestMediaLimit: Int = 0, response: @escaping ([QuestChannel], ErrorData?) -> Void) {
        QuestChannelBO.fetchChannels(withAuthorId: authorId, params: params, featuredMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit, response: response)
    }
    
    static func fetchChannel(withId id: String, authorId: String? = nil, params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int = 0, latestMediaLimit: Int = 0, seriesContent: Bool = false, response: @escaping (QuestChannel?, ErrorData?) -> Void) {
        QuestChannelBO.fetchChannel(withId: id, authorId: authorId, params: params, featuredMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit, seriesContent: seriesContent, response: response)
    }
    
    static func fetchSeries(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestSeries?, ErrorData?) -> Void) {
        QuestChannelBO.fetchSeries(withId: id, params: params, response: response)
    }
    
    static func fetchMedia(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestMedia?, ErrorData?) -> Void) {
        QuestChannelBO.fetchMedia(withId: id, params: params, response: response)
    }
    
    static func rateMedia(withId id: String, rating: Double, response: @escaping (ErrorData?) -> Void) {
        QuestChannelBO.rateMedia(withId: id, rating: rating, response: response)
    }
    
    static func favouriteMedia(withId id: String, favourite: Bool, response: @escaping (ErrorData?) -> Void) {
        QuestChannelBO.favouriteMedia(withId: id, favourite: favourite, response: response)
    }
    
    static func attendMedia(withId id: String, attend: Bool, response: @escaping (ErrorData?) -> Void) {
        QuestChannelBO.attendMedia(withId: id, attend: attend, response: response)
    }
    
    // Mindvalley channels
    
    public static func fetchMVChannels(withAuthorId authorId: String? = nil, authorized: Bool = true, params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int = 0, latestMediaLimit: Int = 0, sortSeriesBy: String = "latest", response: @escaping ([QuestChannel], ErrorData?) -> Void) {
        DispatchQueue.main.async {
            MindvalleyChannelsNS.shared.fetchChannels(withAuthorId: authorId, authorized: authorized, params: params, featuredMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit, sortSeriesBy: sortSeriesBy, response: response)
        }
    }
    
    static func fetchMVChannel(withId id: String, authorId: String? = nil, params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int = 0, latestMediaLimit: Int = 0, seriesContent: Bool = false, response: @escaping (QuestChannel?, ErrorData?) -> Void) {
        DispatchQueue.main.async {
            MindvalleyChannelsNS.shared.fetchChannel(withId: id, authorId: authorId, params: params, featuredMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit, seriesContent: seriesContent, response: response)
        }
    }
    
    static func fetchMVCategories(withAuthorId authorId: String? = nil,params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int = 0, latestMediaLimit: Int = 0, response: @escaping ([ChannelCategory]?, ErrorData?) -> Void) {
        DispatchQueue.main.async {
            ChannelCategoriesNS.shared.getChannelCategories(params: params, response)
        }
    }
    
    static func fetchMVSeries(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestSeries?, ErrorData?) -> Void) {
        DispatchQueue.main.async {
            MindvalleyChannelsNS.shared.fetchSeries(withId: id, params: params, response: response)
        }
    }
    
    static func fetchMVMedia(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestMedia?, ErrorData?) -> Void) {
        DispatchQueue.main.async {
            MindvalleyChannelsNS.shared.fetchMedia(withId: id, params: params, response: response)
        }
    }
    
    static func fetchMVMediaList(sort: String, limit: Int, page: Int = 1, authorized:Bool = true, categoryId: String? = nil, channelId: String? = nil, seriesId: Int? = nil, status: String = "", params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([QuestMedia]?, ErrorData?) -> Void) {
        DispatchQueue.main.async {
            MindvalleyChannelsNS.shared.fetchMediaList(sort: sort, limit: limit, page: page, authorized: authorized, categoryId: categoryId, channelId: channelId, seriesId: seriesId, status: status, response: response)
        }
    }
}
