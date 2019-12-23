//
//  MVAnalyticsEventMP.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/10/18.
//

import Foundation

struct MVAnalyticsEventMP {
    
    static func parse(_ data: Data) -> MVAnalyticsEvent? {
        do {
            let decoded = try JSONDecoder().decode(MVAnalyticsEvent.self, from: data)
            return decoded
        } catch {
            print("\(#function) error: \(error)")
        }
        return nil
    }
    
    static func encode(_ object: MVAnalyticsEvent) -> Data? {
        do {
            let encoded = try JSONEncoder().encode(object)
            return encoded
        } catch {
            print("\(#function) error: \(error)")
        }
        return nil
    }
    
}
