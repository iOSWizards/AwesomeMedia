//
//  QuestChannelBO.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 7/23/18.
//

import Foundation

public struct QuestChannelBO {
    
    static var questChannelNS = QuestChannelNS.shared
    //static var questDA = QuestDA()
    
    private init() {}
    
    public static func fetchChannels(withAuthorId authorId: String? = nil, params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int, latestMediaLimit: Int, response: @escaping ([QuestChannel], ErrorData?) -> Void) {
        
        func sendResponse(_ channels: [QuestChannel], _ error: ErrorData?) {
            DispatchQueue.main.async { response(channels, error) }
        }
        
        func fetchFromAPI() {
            questChannelNS.fetchChannels(withAuthorId: authorId, params: params, featuredMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit) { (channels, error) in
                sendResponse(channels, error)
            }
        }
        
        fetchFromAPI()
    }
    
    public static func fetchChannel(withId id: String, authorId: String? = nil, params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int, latestMediaLimit: Int, seriesContent: Bool, response: @escaping (QuestChannel?, ErrorData?) -> Void) {
        func sendResponse(_ channel: QuestChannel?, _ error: ErrorData?) {
            DispatchQueue.main.async { response(channel, error) }
        }
        
        func fetchFromAPI() {
            questChannelNS.fetchChannel(withId: id, authorId: authorId, params: params, featuredMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit, seriesContent: seriesContent) { (channel, error) in
                DispatchQueue.main.async {
                    response(channel, error)
                }
            }
        }
        
        fetchFromAPI()
    }

    public static func fetchSeries(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestSeries?, ErrorData?) -> Void) {
        func sendResponse(_ series: QuestSeries?, _ error: ErrorData?) {
            DispatchQueue.main.async { response(series, error) }
        }
        
        func fetchFromAPI() {
            questChannelNS.fetchSeries(withId: id, params: params) { (series, error) in
                DispatchQueue.main.async {
                    response(series, error)
                }
            }
        }
        
        fetchFromAPI()
    }
    
    public static func fetchMedia(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestMedia?, ErrorData?) -> Void) {
        func sendResponse(_ media: QuestMedia?, _ error: ErrorData?) {
            DispatchQueue.main.async { response(media, error) }
        }
        
        func fetchFromAPI() {
            questChannelNS.fetchMedia(withId: id, params: params) { (media, error) in
                DispatchQueue.main.async {
                    response(media, error)
                }
            }
        }
        
        fetchFromAPI()
    }
    
    public static func rateMedia(withId id: String, rating: Double, response: @escaping (ErrorData?) -> Void) {
        questChannelNS.rateMedia(withId: id, rating: rating) { (error) in
            DispatchQueue.main.async {
                response(error)
            }
        }
    }
    
    public static func favouriteMedia(withId id: String, favourite: Bool, response: @escaping (ErrorData?) -> Void) {
        questChannelNS.favouriteMedia(withId: id, favourite: favourite) { (error) in
            DispatchQueue.main.async {
                response(error)
            }
        }
    }
    
    public static func attendMedia(withId id: String, attend: Bool, response: @escaping (ErrorData?) -> Void) {
        questChannelNS.attendMedia(withId: id, attend: attend) { (error) in
            DispatchQueue.main.async {
                response(error)
            }
        }
    }
    
}
