//
//  MVAnalyticsIdentifyContext.swift
//  Auth0-iOS10.0
//
//  Created by Evandro Harrison Hoffmann on 10/17/18.
//

import Foundation

public struct MVAnalyticsIdentifyContext: Codable {
    
    public var appsflyerDeviceId: String
    public var deviceId: String
    public var appName: String
    public var appVersion: String
    public var os: String
    public var ip: String
    
    public init(appsflyerDeviceId: String,
                deviceId: String,
                appName: String,
                appVersion: String,
                os: String,
                ip: String) {
        
        self.appsflyerDeviceId = appsflyerDeviceId
        self.deviceId = deviceId
        self.appName = appName
        self.appVersion = appVersion
        self.os = os
        self.ip = ip
    }
    
    // MARK: - Coding keys
    
    private enum CodingKeys: String, CodingKey {
        case appsflyerDeviceId = "appsflyer_device_id"
        case deviceId = "device_id"
        case appName = "app_name"
        case appVersion = "app_version"
        case os
        case ip
    }
}
