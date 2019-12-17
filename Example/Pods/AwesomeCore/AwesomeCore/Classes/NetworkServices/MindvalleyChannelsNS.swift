//
//  MindvalleyChannelsNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 16/05/19.
//

import Foundation

import Foundation

class MindvalleyChannelsNS: BaseNS {
    
    static let shared = MindvalleyChannelsNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    let url = ACConstants.shared.questsURL
    let method: URLMethod = .POST
    
    func fetchChannels(withAuthorId authorId: String? = nil, authorized: Bool = true, params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int, latestMediaLimit: Int, sortSeriesBy: String, response: @escaping ([QuestChannel], ErrorData?) -> Void) {
        
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
        
        let jsonBody = MindvalleyChannelsGraphQLModel.queryChannels(withAuthorId: authorId, featuredMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit, sortSeriesBy: sortSeriesBy)
        
        // Data From Cache
        if params.contains(.shouldFetchFromCache) {
            if let data = dataFromCache(url, method: method, params: params, bodyDict: jsonBody) {
                _ = processResponse(data: data, response: response)
            }
        }
        
        // Data from API
        if authorized {
            _ = requester.performRequestAuthorized(
                url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                    if processResponse(data: data, error: error, response: response) {
                        self.saveToCache(self.url, method: self.method, bodyDict: jsonBody, data: data)
                    }
            })
        } else {
            _ = requester.performRequest(
                url, method: method, forceUpdate: true, jsonBody: jsonBody, headers: ["x-mv-app" : "mv-ios"], completion: { (data, error, responseType) in
                    if processResponse(data: data, error: error, response: response) {
                        self.saveToCache(self.url, method: self.method, bodyDict: jsonBody, data: data)
                    }
            })
        }
        
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
        
        let jsonBody = MindvalleyChannelsGraphQLModel.querySingleChannelModel(withId: id, authorId: authorId, featuredMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit, seriesContent: seriesContent)
        
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
        
        let jsonBody = MindvalleyChannelsGraphQLModel.querySingleSeriesModel(withId: id)
        
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
        
        let jsonBody = MindvalleyChannelsGraphQLModel.querySingleMediaModel(withId: id)
        
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
    
    
    func fetchMediaList(sort: String, limit: Int, page: Int, authorized: Bool = true, categoryId: String?, channelId: String?, seriesId: Int?, status: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([QuestMedia]?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([QuestMedia]?, ErrorData?) -> Void) -> Bool {
            guard let data = data else {
                //response(nil, nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            let media = MediaListMP.parseMediaFrom(data)
            response(media, nil)
            return true
        }
        
        let jsonBody = MindvalleyChannelsGraphQLModel.queryMediaListModel(sort: sort, limit: limit, page: page, categoryId: categoryId, channelId: channelId, seriesId: seriesId, status: status)
        
        //Data From Cache
        if params.contains(.shouldFetchFromCache) {
            if let data = dataFromCache(url, method: method, params: params, bodyDict: jsonBody) {
                _ = processResponse(data: data, response: response)
            }
        }
        
        if authorized {
            // Fetch from API
            _ = requester.performRequestAuthorized(
                url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                    if processResponse(data: data, error: error, response: response) {
                        self.saveToCache(self.url, method: self.method, bodyDict: jsonBody, data: data)
                    }
            })
        } else {
            // Fetch from API
            _ = requester.performRequest(
                url, method: method, forceUpdate: true, jsonBody: jsonBody, headers: ["x-mv-app" : "mv-ios"], completion: { (data, error, responseType) in
                    if processResponse(data: data, error: error, response: response) {
                        self.saveToCache(self.url, method: self.method, bodyDict: jsonBody, data: data)
                    }
            })
        }
        
    }
    
}

