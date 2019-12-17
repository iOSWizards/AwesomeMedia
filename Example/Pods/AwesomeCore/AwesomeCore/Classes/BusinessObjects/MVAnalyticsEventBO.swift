//
//  MVAnalyticsEventBO.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/10/18.
//

import Foundation

public struct MVAnalyticsEventBO {
    
    static var mvAnalyticsEventNS = MVAnalyticsEventNS.shared
    
    private init() {}
    
    public static func track(_ event: MVAnalyticsEvent, params: AwesomeCoreNetworkServiceParams, response: @escaping (MVAnalyticsIdentifyStatus?, ErrorData?) -> Void) {
        mvAnalyticsEventNS.track(event, params: params) { (status, error) in
            DispatchQueue.main.async {
                response(status, error)
            }
        }
    }
    
}
