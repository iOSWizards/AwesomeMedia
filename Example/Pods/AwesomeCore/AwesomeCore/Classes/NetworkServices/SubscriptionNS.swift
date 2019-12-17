//
//  SubscriptionNS.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 11/09/2017.
//

import Foundation

class SubscriptionNS: BaseNS {
    
    static let shared = SubscriptionNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    var lastSubscriptionsRequest: URLSessionDataTask?
    
    func fetchSubscriptions(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Subscription], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([Subscription], ErrorData?) -> Void ) -> Bool {
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.lastSubscriptionsRequest = nil
                response(SubscriptionMP.parseSubscriptionsFrom(jsonObject, key: "subscriptions"), nil)
                return true
            } else {
                self.lastSubscriptionsRequest = nil
                if let error = error {
                    response([Subscription](), error)
                    return false
                }
                response([Subscription](), ErrorData(.unknown, "response Data could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.shared.librarySubscriptionURL
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        lastSubscriptionsRequest = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: nil, data: data)
                }
        })
    }
}
