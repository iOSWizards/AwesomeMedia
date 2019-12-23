//
//  QuestProductNS.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/7/17.
//

import Foundation

class QuestProductNS: BaseNS {
    
    static let shared = QuestProductNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    var lastQuestProductsRequest: URLSessionDataTask?
    var lastQuestProductRequest: URLSessionDataTask?
    var lastQuestRedeemableRequest: URLSessionDataTask?
    
    let method: URLMethod = .POST
    let url = ACConstants.shared.questsURL
    
    func fetchProducts(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([QuestProduct], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([QuestProduct], ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response([], nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response([], error)
                return false
            }
            
            let products = QuestProductMP.parseQuestProductsFrom(data)
            response(products, nil)
            return products.count > 0
        }
        
        let jsonBody = QuestProductGraphQLModel.queryProducts()
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: jsonBody), response: response)
        }
        
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(self.url, method: self.method, bodyDict: jsonBody, data: data)
                }
        })
    }
    
    func fetchProduct(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestProduct?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (QuestProduct?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response(nil, nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            let product = QuestProductMP.parseQuestProductFrom(data)
            response(product, nil)
            return product != nil
        }
        
        let jsonBody = QuestProductGraphQLModel.querySingleProduct(withId: id)
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: jsonBody), response: response)
        }
        
        _ = requester.performRequest(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(self.url, method: self.method, bodyDict: jsonBody, data: data)
                }
        })
    }
    
    func fetchRedeemableProducts(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([QuestProduct], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([QuestProduct], ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response([], nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response([], error)
                return false
            }
            
            let products = QuestProductMP.parseQuestRedeemableProductsFrom(data)
            response(products, nil)
            return products.count > 0
        }
        
        let jsonBody = QuestProductGraphQLModel.queryRedeemableProducts()
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: jsonBody), response: response)
        }
        
        _ = requester.performRequest(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(self.url, method: self.method, bodyDict: jsonBody, data: data)
                }
        })
    }
    
}

