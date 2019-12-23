//
//  MVAnalyticsIdentifyTraits.swift
//  Auth0-iOS10.0
//
//  Created by Evandro Harrison Hoffmann on 10/17/18.
//

import Foundation

public struct MVAnalyticsIdentifyTraits: Codable {
    public var email: String
    
    public init(email: String) {
        
        self.email = email
    }
}
