//
//  MVAnalyticsEvent.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/10/18.
//

import Foundation

public struct MVAnalyticsEvent: Codable {
    
    public var event: [MVAnalyticsEventContent]
    
    public init(event: [MVAnalyticsEventContent]) {
        self.event = event
    }
    
    // MARK: - Encoding
    
    public var encoded: Data? {
        return MVAnalyticsEventMP.encode(self)
    }
}

public struct MVAnalyticsEventContent: Codable {
    
    public init(published: String,
                actor: MVAnalyticsEventActor,
                verb: String,
                object: MVAnalyticsEventObject) {
        self.published = published
        self.actor = actor
        self.verb = verb
        self.object = object
    }
    
    public var published: String
    public var actor: MVAnalyticsEventActor
    public var verb: String
    public var object: MVAnalyticsEventObject
    
}
