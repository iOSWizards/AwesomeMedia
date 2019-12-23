//
//  PRKUserMP.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 8/30/18.
//

import Foundation

struct PRKUserMP {
    
    static func parseUser(_ data: Data) -> PRKUser? {
        do {
            let decoded = try JSONDecoder().decode(PRKUserKey.self, from: data)
            return decoded.user
        } catch {
            print("\(#function) error: \(error)")
        }
        return nil
    }
    
}
