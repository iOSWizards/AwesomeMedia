//
//  MVAnalyticsIdentifyBO.swift
//  Auth0-iOS10.0
//
//  Created by Evandro Harrison Hoffmann on 10/17/18.
//

import Foundation

public struct MVAnalyticsIdentifyBO {
    
    static var mvAnalyticsIdentifyNS = MVAnalyticsIdentifyNS.shared
    
    private init() {}
    
    public static func identify(_ identify: MVAnalyticsIdentify, params: AwesomeCoreNetworkServiceParams, response: @escaping (MVAnalyticsIdentifyStatus?, ErrorData?) -> Void) {
        mvAnalyticsIdentifyNS.identify(identify, params: params) { (status, error) in
            DispatchQueue.main.async {
                response(status, error)
            }
        }
    }
    
}
