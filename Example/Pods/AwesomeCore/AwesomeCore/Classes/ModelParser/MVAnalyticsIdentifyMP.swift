//
//  MVAnalyticsIdentifyMP.swift
//  Auth0-iOS10.0
//
//  Created by Evandro Harrison Hoffmann on 10/17/18.
//

import Foundation

struct MVAnalyticsIdentifyMP {
    
    static func parse(_ data: Data) -> MVAnalyticsIdentify? {
        do {
            let decoded = try JSONDecoder().decode(MVAnalyticsIdentify.self, from: data)
            return decoded
        } catch {
            print("\(#function) error: \(error)")
        }
        return nil
    }
    
    static func encode(_ object: MVAnalyticsIdentify) -> Data? {
        do {
            let encoded = try JSONEncoder().encode(object)
            return encoded
        } catch {
            print("\(#function) error: \(error)")
        }
        return nil
    }
    
}
