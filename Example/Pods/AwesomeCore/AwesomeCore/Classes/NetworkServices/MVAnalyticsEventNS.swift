//
//  MVAnalyticsEventNS.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/10/18.
//

import Foundation

class MVAnalyticsEventNS: BaseNS {
    
    static let shared = MVAnalyticsEventNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    func track(_ event: MVAnalyticsEvent, params: AwesomeCoreNetworkServiceParams, _ response:@escaping (MVAnalyticsIdentifyStatus?, ErrorData?) -> Void) {
        
        _ = requester.performRequestAuthorized(
            ACConstants.shared.mvAnalyticsEventURL, forceUpdate: true, headersParam: ACConstants.shared.analyticsHeadersMV, method: .POST, jsonBody: event.encoded, completion: { (data, error, responseType) in
                guard let data = data else {
                    response(nil, nil)
                    return
                }
                
                if let error = error {
                    print("Error fetching from API: \(error.message)")
                    response(nil, error)
                    return
                }
                
                let status = MVAnalyticsIdentifyStatusMP.parse(data)
                response(status, nil)
        })
    }
    
}
