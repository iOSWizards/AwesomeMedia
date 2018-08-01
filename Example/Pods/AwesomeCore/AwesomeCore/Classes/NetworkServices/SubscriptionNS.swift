//
//  SubscriptionNS.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 11/09/2017.
//

import Foundation

class SubscriptionNS {
    
    static let shared = SubscriptionNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var lastSubscriptionsRequest: URLSessionDataTask?
    
    func fetchSubscriptions(forcingUpdate: Bool = false, response: @escaping ([Subscription], ErrorData?) -> Void) {
        
        lastSubscriptionsRequest?.cancel()
        lastSubscriptionsRequest = nil
        
        lastSubscriptionsRequest = awesomeRequester.performRequestAuthorized(
            ACConstants.shared.librarySubscriptionURL, forceUpdate: forcingUpdate, completion: { (data, error, responseType) in
                
                if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                    self.lastSubscriptionsRequest = nil
                    response(SubscriptionMP.parseSubscriptionsFrom(jsonObject, key: "subscriptions"), nil)
                } else {
                    self.lastSubscriptionsRequest = nil
                    if let error = error {
                        response([Subscription](), error)
                        return
                    }
                    response([Subscription](), ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
}
