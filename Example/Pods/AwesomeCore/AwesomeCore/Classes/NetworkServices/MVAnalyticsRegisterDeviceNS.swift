//
//  MVAnalyticsRegisterDeviceNS.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 18/03/19.
//

import Foundation

class MVAnalyticsRegisterDeviceNS: BaseNS {
    
    static let shared = MVAnalyticsRegisterDeviceNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    func register(_ register: MVAnalyticsRegisterDevice, params: AwesomeCoreNetworkServiceParams, _ response:@escaping (MVAnalyticsIdentifyStatus?, ErrorData?) -> Void) {

        _ = requester.performRequestAuthorized(
            ACConstants.shared.mvAnalyticsRegisterURL, headersParam: ACConstants.shared.analyticsHeadersMV, method: .POST, jsonBody: register.encoded, completion: { (data, error, responseType) in
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
