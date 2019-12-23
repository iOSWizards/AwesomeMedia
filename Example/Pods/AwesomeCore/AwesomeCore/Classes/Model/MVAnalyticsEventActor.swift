//
//  MVAnalyticsEventActor.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/10/18.
//

import Foundation

public struct MVAnalyticsEventActor: Codable {
    
    public var objectType: String
    public var id: String
    public var appVersion: String
    public var os: String
    public var osVersion: String
    public var deviceBrand: String
    public var model: String
    public var appName: String
    public var deviceId: String
    public var platform: String
    public var version: String?
    public var email: String
    
    public init(objectType: String,
                id: String,
                appVersion: String,
                os: String,
                osVersion: String,
                deviceBrand: String,
                model: String,
                appName: String,
                deviceId: String,
                platform: String,
                version: String? = nil,
                email: String) {
        
        self.objectType = objectType
        self.id = id
        self.appVersion = appVersion
        self.os = os
        self.osVersion = osVersion
        self.deviceBrand = deviceBrand
        self.model = model
        self.appName = appName
        self.deviceId = deviceId
        self.platform = platform
        self.version = version
        self.email = email
        
    }
    
    // MARK: - Coding keys
    
    private enum CodingKeys: String, CodingKey {
        case objectType = "object_type"
        case id
        case appVersion = "app_version"
        case os
        case osVersion = "os_version"
        case deviceBrand = "device_brand"
        case model
        case appName = "app_name"
        case deviceId = "device_id"
        case platform
        case version
        case email
    }
    
}
