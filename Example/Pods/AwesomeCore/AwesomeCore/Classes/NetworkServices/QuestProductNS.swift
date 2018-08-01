//
//  QuestProductNS.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/7/17.
//

import Foundation

class QuestProductNS {
    
    static let shared = QuestProductNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var lastQuestProductsRequest: URLSessionDataTask?
    var lastQuestProductRequest: URLSessionDataTask?
    var lastQuestRedeemableRequest: URLSessionDataTask?
    
    func fetchProducts(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([QuestProduct], ErrorData?) -> Void) {
        
        var didRespondCachedData = false
        
        func processResponse(data: Data?, response: @escaping ([QuestProduct], ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            let products = QuestProductMP.parseQuestProductsFrom(data)
            response(products, nil)
            
            return products.count > 0
        }
        
        func fetchFromAPI(forceUpdate: Bool) {
            
            // cancel previews request only if should
            if params.contains(.canCancelRequest) {
                lastQuestProductsRequest?.cancel()
                lastQuestProductsRequest = nil
            }
            
            lastQuestProductsRequest = requester.performRequestAuthorized(
                ACConstants.shared.questsURL, forceUpdate: forceUpdate, method: .POST, jsonBody: QuestProductGraphQLModel.queryProducts(), completion: { (data, error, responseType) in
                    self.lastQuestProductsRequest = nil
                    
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
    
    func fetchProduct(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestProduct?, ErrorData?) -> Void) {
        
        var didRespondCachedData = false
        
        func processResponse(data: Data?, response: @escaping (QuestProduct?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            let product = QuestProductMP.parseQuestProductFrom(data)
            response(product, nil)
            
            return product != nil
        }
        
        func fetchFromAPI(forceUpdate: Bool) {
            
            // cancel previews request only if should
            if params.contains(.canCancelRequest) {
                lastQuestProductRequest?.cancel()
                lastQuestProductRequest = nil
            }
            
            lastQuestProductRequest = requester.performRequest(
                ACConstants.shared.questsURL, forceUpdate: forceUpdate, method: .POST, jsonBody: QuestProductGraphQLModel.querySingleProduct(withId: id), completion: { (data, error, responseType) in
                    self.lastQuestProductRequest = nil
                    
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
    
    func fetchRedeemableProducts(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([QuestProduct], ErrorData?) -> Void) {
        
        var didRespondCachedData = false
        
        func processResponse(data: Data?, response: @escaping ([QuestProduct], ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            let products = QuestProductMP.parseQuestRedeemableProductsFrom(data)
            response(products, nil)
            
            return products.count > 0
        }
        
        func fetchFromAPI(forceUpdate: Bool) {
            
            // cancel previews request only if should
            if params.contains(.canCancelRequest) {
                lastQuestRedeemableRequest?.cancel()
                lastQuestRedeemableRequest = nil
            }
            
            lastQuestRedeemableRequest = requester.performRequest(
                ACConstants.shared.questsURL, forceUpdate: forceUpdate, method: .POST, jsonBody: QuestProductGraphQLModel.queryRedeemableProducts(), completion: { (data, error, responseType) in
                    self.lastQuestProductsRequest = nil
                    
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
    
}

