//
//  QuestChannelNS.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 7/23/18.
//

import Foundation

class QuestChannelNS {
    
    static let shared = QuestChannelNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var lastQuestChannelsRequest: URLSessionDataTask?
    var lastQuestChannelRequest: URLSessionDataTask?
    
    func fetchChannels(params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int, latestMediaLimit: Int, response: @escaping ([QuestChannel], ErrorData?) -> Void) {
        
        var didRespondCachedData = false
        
        func processResponse(data: Data?, response: @escaping ([QuestChannel], ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            let channels = QuestChannelMP.parseChannelsFrom(data)
            response(channels, nil)
            
            return channels.count > 0
        }
        
        func fetchFromAPI(forceUpdate: Bool) {
            
            // cancel previews request only if should
            if params.contains(.canCancelRequest) {
                lastQuestChannelRequest?.cancel()
                lastQuestChannelRequest = nil
            }
            
            lastQuestChannelsRequest = requester.performRequestAuthorized(
                ACConstants.shared.questsURL, forceUpdate: forceUpdate, method: .POST, jsonBody: QuestChannelGraphQLModel.queryChannels(withFeaturedMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit), completion: { (data, error, responseType) in
                    
                    //process response
                    let hasResponse = processResponse(data: data, response: response)
                    
                    //fetches again based on response type
                    if !forceUpdate && responseType == .cached {
                        didRespondCachedData = hasResponse
                        
                        fetchFromAPI(forceUpdate: true)
                    } else if let error = error {
                        print("Error fetching from API: \(error.message)")
                        
                        if !didRespondCachedData {
                            response([], error)
                        }
                    }
            })
        }
        
        // fetches from cache if the case
        if params.contains(.shouldFetchFromCache) {
            fetchFromAPI(forceUpdate: false)
        } else {
            fetchFromAPI(forceUpdate: true)
        }
    }
    
    func fetchChannel(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int, latestMediaLimit: Int, response: @escaping (QuestChannel?, ErrorData?) -> Void) {
        
        var didRespondCachedData = false
        
        func processResponse(data: Data?, response: @escaping (QuestChannel?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            let channel = QuestChannelMP.parseChannelFrom(data)
            response(channel, nil)
            
            return channel != nil
        }
        
        func fetchFromAPI(forceUpdate: Bool) {
            
            // cancel previews request only if should
            if params.contains(.canCancelRequest) {
                lastQuestChannelRequest?.cancel()
                lastQuestChannelRequest = nil
            }
            
            lastQuestChannelRequest = requester.performRequestAuthorized(
                ACConstants.shared.questsURL, forceUpdate: forceUpdate, method: .POST, jsonBody: QuestChannelGraphQLModel.querySingleChannelModel(withId: id, featuredMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit), completion: { (data, error, responseType) in
                    self.lastQuestChannelRequest = nil
                    
                    //process response
                    let hasResponse = processResponse(data: data, response: response)
                    
                    //fetches again based on response type
                    if !forceUpdate && responseType == .cached {
                        didRespondCachedData = hasResponse
                        
                        fetchFromAPI(forceUpdate: true)
                    } else if let error = error {
                        print("Error fetching from API: \(error.message)")
                        
                        if !didRespondCachedData {
                            response(nil, error)
                        }
                    }
            })
        }
        
        // fetches from cache if the case
        if params.contains(.shouldFetchFromCache) {
            fetchFromAPI(forceUpdate: false)
        } else {
            fetchFromAPI(forceUpdate: true)
        }
    }
    
}
