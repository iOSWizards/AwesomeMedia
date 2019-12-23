//
//  AwesomeCore+MVAnalytics.swift
//  Auth0-iOS10.0
//
//  Created by Evandro Harrison Hoffmann on 10/17/18.
//

import Foundation

public extension AwesomeCore {
    
    public static func identify(_ identify: MVAnalyticsIdentify, params: AwesomeCoreNetworkServiceParams, response: @escaping (MVAnalyticsIdentifyStatus?, ErrorData?) -> Void) {
        MVAnalyticsIdentifyBO.identify(identify, params: params, response: response)
    }
    
    public static func track(_ event: MVAnalyticsEvent, params: AwesomeCoreNetworkServiceParams, response: @escaping (MVAnalyticsIdentifyStatus?, ErrorData?) -> Void) {
        MVAnalyticsEventBO.track(event, params: params, response: response)
    }
    
    public static func register(_ register: MVAnalyticsRegisterDevice, params: AwesomeCoreNetworkServiceParams, response: @escaping (MVAnalyticsIdentifyStatus?, ErrorData?) -> Void) {
        MVAnalyticsRegisterDeviceNS.shared.register(register, params: params) { (status, error) in
            DispatchQueue.main.async {
                response(status, error)
            }
        }
    }
    
}

