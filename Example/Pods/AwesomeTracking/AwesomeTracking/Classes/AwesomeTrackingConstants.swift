//
//  AwesomeTrackingConstants.swift
//  AwesomeTracking
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/10/19.
//

import Foundation

struct AwesomeTrackingConstants {
    
    static private let analyticsV2Url: String = AwesomeTracking.shared.development ? "https://analytics.mvstg.com/v2/" : "https://analytics.mindvalley.com/v2/"
    
    static let stagingClientId: String = AwesomeTracking.shared.development ? "bebb6d2a-4b18-47da-b38a-4aed6dfc4094" : "57ff4749-cff8-4807-88c1-a272d97171bb"
    static let stagingSecretId: String = AwesomeTracking.shared.development ? "171b5d54a46b86969892e669b8298a52" : "cadd3837689f8af0518f1faa8d09497c"
    
    static let registerUrl: String = "\(AwesomeTrackingConstants.analyticsV2Url)register"
    static let identifyUrl: String = "\(AwesomeTrackingConstants.analyticsV2Url)identify"
    static let eventsUrl: String = "\(AwesomeTrackingConstants.analyticsV2Url)events"
    
}

// MARK: - Computed properties

extension AwesomeTrackingConstants {
    
    static let deviceId: String = {
        if let device = UIDevice.current.identifierForVendor?.uuidString {
            return device
        }
        return "not set"
    }()
    
}
