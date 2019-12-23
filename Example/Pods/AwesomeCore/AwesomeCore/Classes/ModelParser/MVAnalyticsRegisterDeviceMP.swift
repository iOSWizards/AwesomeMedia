//
//  MVAnalyticsRegisterDeviceMP.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 18/03/19.
//

import Foundation

struct MVAnalyticsRegisterDeviceMP {
    
    static func encodeDevice(_ object: MVAnalyticsRegisterDevice) -> Data? {
        do {
            let encoded = try JSONEncoder().encode(object)
            return encoded
        } catch {
            print("\(#function) error: \(error)")
        }
        return nil
    }
    
}
