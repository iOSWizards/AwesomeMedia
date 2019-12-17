//
//  MVAnalyticsIdentify.swift
//  Auth0-iOS10.0
//
//  Created by Evandro Harrison Hoffmann on 10/17/18.
//

import Foundation

public struct MVAnalyticsIdentify: Codable {
    
    public let userId: String
    public let context: MVAnalyticsIdentifyContext
    public let traits: MVAnalyticsIdentifyTraits
    
    public init(userId: String,
                context: MVAnalyticsIdentifyContext,
                traits: MVAnalyticsIdentifyTraits) {
        
        self.userId = userId
        self.context = context
        self.traits = traits
    }
    
    // MARK: - Coding keys
    
    private enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case context
        case traits
    }
    
    // MARK: - Encoding
    
    public var encoded: Data? {
        return MVAnalyticsIdentifyMP.encode(self)
    }
    
}
