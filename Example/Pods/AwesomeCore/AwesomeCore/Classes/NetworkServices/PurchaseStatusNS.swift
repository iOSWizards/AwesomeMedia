//
//  PurchaseStatusNS.swift
//  AwesomeCore-iOS10.0
//
//  Created by Emmanuel on 16/07/2018.
//

import Foundation

class PurchaseStatusNS {
    
    static let shared = PurchaseStatusNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var lastPurchaseStatusRequest: URLSessionDataTask?
    
    var purchaseStatusRequests = [String: URLSessionDataTask]()
    
    func fetchPurchaseStatus(eventSlug: EventCode, params: AwesomeCoreNetworkServiceParams = .standard, forceUpdate: Bool = false, response: @escaping (PurchaseStatus?, ErrorData?) -> Void) {
        
        var didRespondCachedData = false
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.eventPurchaseStatusURL, with: eventSlug.rawValue)
        
        func fetchFromAPI(forceUpdate: Bool) {
            
            // cancel previews request only if should
            if params.contains(.canCancelRequest) {
                purchaseStatusRequests[url]?.cancel()
                purchaseStatusRequests[url] = nil
            }
            
            purchaseStatusRequests[url] = awesomeRequester.performRequestAuthorized(url, forceUpdate: forceUpdate, method: .GET, completion: { (data, error, responseType) in
                
                if let jsonObject = data {
                    self.lastPurchaseStatusRequest = nil
                    response(PurchaseStatusMP.parsePurchaseStatusFrom(jsonObject), nil)
                    
                    if !forceUpdate && responseType == .cached {
                        didRespondCachedData = true
                        fetchFromAPI(forceUpdate: true)
                    }
                } else {
                    self.lastPurchaseStatusRequest = nil
                    if let error = error {
                        response(nil, error)
                        return
                    }
                    response(nil, ErrorData(.unknown, "PurchaseStatusNS Data could not be parsed"))
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
