//
//  QuestChannelNS.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 7/23/18.
//

import Foundation

class QuestChannelNS: BaseNS {
    
    static let shared = QuestChannelNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    let url = ACConstants.shared.questsURL
    let method: URLMethod = .POST
    
    func fetchChannels(withAuthorId authorId: String? = nil, params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int, latestMediaLimit: Int, response: @escaping ([QuestChannel], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([QuestChannel], ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                //response([], nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response([], error)
                return false
            }
            
            let channels = QuestChannelMP.parseChannelsFrom(data)
            response(channels, nil)
            return channels.count > 0
        }
        
        let jsonBody = QuestChannelGraphQLModel.queryChannels(withAuthorId: authorId, featuredMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit)
        
        // Data From Cache
        if params.contains(.shouldFetchFromCache) {
            if let data = dataFromCache(url, method: method, params: params, bodyDict: jsonBody) {
                _ = processResponse(data: data, response: response)
            }
        }
        
        // Data from API
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(self.url, method: self.method, bodyDict: jsonBody, data: data)
                }
        })
    }
    
    func fetchChannel(withId id: String, authorId: String? = nil, params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int, latestMediaLimit: Int, seriesContent: Bool, response: @escaping (QuestChannel?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (QuestChannel?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                //response(nil, nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            let channel = QuestChannelMP.parseChannelFrom(data)
            response(channel, nil)
            return channel != nil
        }
        
        let jsonBody = QuestChannelGraphQLModel.querySingleChannelModel(withId: id, authorId: authorId, featuredMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit, seriesContent: seriesContent)
        
        // Data From Cache
        if params.contains(.shouldFetchFromCache) {
            if let data = dataFromCache(url, method: method, params: params, bodyDict: jsonBody) {
                _ = processResponse(data: data, response: response)
            }
        }
        
        // Data from API
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(self.url, method: self.method, bodyDict: jsonBody, data: data)
                }
        })
    }
    
    func fetchSeries(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestSeries?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (QuestSeries?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                //response(nil, nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            let series = QuestSeriesMP.parseSerieFrom(data)
            response(series, nil)
            return series != nil
        }
        
        let jsonBody = QuestChannelGraphQLModel.querySingleSeriesModel(withId: id)
        
        // Data From Cache
        if params.contains(.shouldFetchFromCache) {
            if let data = dataFromCache(url, method: method, params: params, bodyDict: jsonBody) {
                _ = processResponse(data: data, response: response)
            }
        }
        
        // Data from API
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(self.url, method: self.method, bodyDict: jsonBody, data: data)
                }
        })
    }
    
    func fetchMedia(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestMedia?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (QuestMedia?, ErrorData?) -> Void) -> Bool {
            guard let data = data else {
                //response(nil, nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            let media = QuestMediaMP.parseMediaFrom(data)
            response(media, nil)
            return true
        }
        
        let jsonBody = QuestChannelGraphQLModel.querySingleMediaModel(withId: id)
        
        // Data From Cache
        if params.contains(.shouldFetchFromCache) {
            if let data = dataFromCache(url, method: method, params: params, bodyDict: jsonBody) {
                _ = processResponse(data: data, response: response)
            }
        }
        
        // Fetch from API
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(self.url, method: self.method, bodyDict: jsonBody, data: data)
                }
        })
    }
    
    func rateMedia(withId id: String, rating: Double, response: @escaping (ErrorData?) -> Void) {
        
        _ = requester.performRequestAuthorized(
            url, shouldCache: false, method: method, jsonBody: QuestChannelGraphQLModel.mutationMediaRatingModel(withId: id, rating: rating), completion: { (data, error, responseType) in
                self.process(data: data, error: error, response: response)
        })
    }
    
    func favouriteMedia(withId id: String, favourite: Bool, response: @escaping (ErrorData?) -> Void) {
        
        _ = requester.performRequestAuthorized(
            url, shouldCache: false, method: method, jsonBody: QuestChannelGraphQLModel.mutationFavouriteMediaModel(withId: id, favourite: favourite), completion: { (data, error, responseType) in
                self.process(data: data, error: error, response: response)
        })
    }
    
    func attendMedia(withId id: String, attend: Bool, response: @escaping (ErrorData?) -> Void) {
        
        _ = requester.performRequestAuthorized(
            url, shouldCache: false, method: method, jsonBody: QuestChannelGraphQLModel.mutationAttendMediaModel(withId: id, attend: attend), completion: { (data, error, responseType) in
                self.process(data: data, error: error, response: response)
        })
    }
}
