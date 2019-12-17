//
//  MVAnalyticsIdentifyStatusMP.swift
//  Auth0-iOS10.0
//
//  Created by Evandro Harrison Hoffmann on 10/17/18.
//

import Foundation

struct MVAnalyticsIdentifyStatusMP {
    
    static func parse(_ data: Data) -> MVAnalyticsIdentifyStatus? {
        do {
            let decoded = try JSONDecoder().decode(MVAnalyticsIdentifyStatus.self, from: data)
            return decoded
        } catch {
            print("\(#function) error: \(error)")
        }
        return nil
    }
    
}
