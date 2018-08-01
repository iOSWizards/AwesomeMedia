//
//  EventPurchaseStatusNS.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 25/06/18.
//

import Foundation

class EventPurchaseStatusNS {
    
    static let shared = EventPurchaseStatusNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var requests = [String: URLSessionDataTask]()
    
    func fetchPurchaseStatus(eventSlug: EventCode, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (Bool?, ErrorData?) -> Void) {
        
        var didRespondCachedData = false
        
        func processResponse(data: Data?, response: @escaping (Bool?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            guard let status = String(data: data, encoding: .utf8) else {
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
        
        func fetchFromAPI(forceUpdate: Bool) {
            
            // cancel previews request only if should
            if params.contains(.canCancelRequest) {
                requests[url]?.cancel()
                requests[url] = nil
            }
            
            requests[url] = requester.performRequestAuthorized(
                url, forceUpdate: forceUpdate, method: .GET, completion: { (data, error, responseType) in
                    self.requests[url] = nil
                    
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

