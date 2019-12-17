//
//  MVAnalyticsIdentifyNS.swift
//  Auth0-iOS10.0
//
//  Created by Evandro Harrison Hoffmann on 10/17/18.
//

import Foundation

class MVAnalyticsIdentifyNS: BaseNS {
    
    static let shared = MVAnalyticsIdentifyNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    func identify(_ identify: MVAnalyticsIdentify, params: AwesomeCoreNetworkServiceParams, _ response:@escaping (MVAnalyticsIdentifyStatus?, ErrorData?) -> Void) {
        _ = requester.performRequestAuthorized(
            ACConstants.shared.mvAnalyticsIdentifyURL, forceUpdate: true, headersParam: ACConstants.shared.analyticsHeadersMV, method: .POST, jsonBody: identify.encoded, completion: { (data, error, responseType) in
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
