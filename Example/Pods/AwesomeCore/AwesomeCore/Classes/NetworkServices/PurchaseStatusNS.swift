//
//  PurchaseStatusNS.swift
//  AwesomeCore-iOS10.0
//
//  Created by Emmanuel on 16/07/2018.
//

import Foundation

class PurchaseStatusNS: BaseNS {
    
    static let shared = PurchaseStatusNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    var lastPurchaseStatusRequest: URLSessionDataTask?
    
    var purchaseStatusRequests = [String: URLSessionDataTask]()
    
    func fetchPurchaseStatus(eventSlug: EventCode, params: AwesomeCoreNetworkServiceParams = .standard, forceUpdate: Bool = false, response: @escaping (PurchaseStatus?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (PurchaseStatus?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response(nil, nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            response(PurchaseStatusMP.parsePurchaseStatusFrom(data), nil)
            return true
        }
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.eventPurchaseStatusURL, with: eventSlug.rawValue)
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        _ = awesomeRequester.performRequestAuthorized(url, forceUpdate: true, method: method, completion: { (data, error, responseType) in
            if processResponse(data: data, error: error, response: response) {
                self.saveToCache(url, method: method, bodyDict: nil, data: data)
            }
        })
    }
}
