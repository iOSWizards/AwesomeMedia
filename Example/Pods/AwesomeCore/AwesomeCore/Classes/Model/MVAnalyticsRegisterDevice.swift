//
//  MVAnalyticsRegisterDevice.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 18/03/19.
//

import Foundation

public struct MVAnalyticsRegisterDevice: Codable {
    
    public var register: MVAnalyticsRegisterDeviceInternal
    
    public init(register: MVAnalyticsRegisterDeviceInternal) {
        self.register = register
    }
    
    // MARK: - Encoding
    
    public var encoded: Data? {
        return MVAnalyticsRegisterDeviceMP.encodeDevice(self)
    }
}

public struct MVAnalyticsRegisterDeviceInternal: Codable {
    
    public init(appsflyer_device_id: String,
                braze_id: String,
                mixpanel_id: String,
                device_id: String) {
        self.appsflyer_device_id = appsflyer_device_id
        self.braze_id = braze_id
        self.mixpanel_id = mixpanel_id
        self.device_id = device_id
    }
    
    public var appsflyer_device_id: String
    public var braze_id: String
    public var mixpanel_id: String
    public var device_id: String
    
}
