//
//  EventPurchaseStatusNS.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 25/06/18.
//

import Foundation

class EventPurchaseStatusNS: BaseNS {
    
    static let shared = EventPurchaseStatusNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    var requests = [String: URLSessionDataTask]()
    
    func fetchPurchaseStatus(eventSlug: EventCode, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (Bool?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (Bool?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            guard let status = String(data: data, encoding: .utf8) else {
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                
                response(nil, error)
                return false
            }
            
            if status == "true" {
                response(true, nil)
            } else {
                response(false, nil)
            }
            
            return true
        }
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.eventPurchaseStatusURL, with: eventSlug.rawValue)
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: nil, data: data)
                }
        })
    }
}

