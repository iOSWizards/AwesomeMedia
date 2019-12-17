//
//  CommunityNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 31/01/18.
//

import Foundation

class CommunityNS: BaseNS {
    
    static let shared = CommunityNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    var lastCommunityRequest: URLSessionDataTask?
    
    func fetchCommunities(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (Communities, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (Communities, ErrorData?) -> Void ) -> Bool {
            if let jsonObject = data {
                self.lastCommunityRequest = nil
                
                // parse and save communities
                let communities = CommunityMP.parseCommunitiesFrom(jsonObject).communities
                
                response(communities, nil)
                return true
            } else {
                self.lastCommunityRequest = nil
                if let error = error {
                    response(Communities(publicGroups: [], tribeMembership: [], privateGroups: []), error)
                    return false
                }
                response(Communities(publicGroups: [], tribeMembership: [], privateGroups: []), ErrorData(.unknown, "response Data could not be parsed"))
                return false
            }
        }
        
        let jsonBody: [String: AnyObject] = CommunityGraphQLModel.queryCommunities()
        let method: URLMethod = .POST
        let url: String = ACConstants.shared.questsURL
        
        if params.contains(.shouldFetchFromCache) {
            if let data = dataFromCache(url, method: method, params: params, bodyDict: nil) {
                _ = processResponse(data: data, response: response)
            }
        }
        
        _ = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: jsonBody, data: data)
                }
        })
    }
    
    func fetchCommunities(withProductId productId: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Community], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([Community], ErrorData?) -> Void ) -> Bool {
            if let jsonObject = data {
                // parse and save communities
                let communities = CommunityMP.parseCommunityListFrom(jsonObject)

                response(communities, error)
                return true
            }

            if let error = error {
                response([], error)
            }

            return false
        }
        
        let url = "\(ACConstants.shared.communities)?product_ids=\(productId)"
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            if let data = dataFromCache(url, method: method, params: params, bodyDict: nil) {
                _ = processResponse(data: data, response: response)
            }
        }
        
        _ = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: nil, data: data)
                }
        })
    }
    
}
