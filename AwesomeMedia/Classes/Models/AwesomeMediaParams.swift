//
//  AwesomeMediaParams.swift
//  AwesomeMedia
//
//  Created by Evandro Harrison Hoffmann on 4/9/18.
//

import Foundation

public enum AwesomeMediaParamTypes {
    case url
    case coverUrl
    case author
    case title
    case duration
    case markers
    case size
    case type
    case id
}

public class AwesomeMediaParams {
    public var params: [AwesomeMediaParamTypes: Any] = [:]
    
    public init() {
        params = [:]
    }
    
    public init(_ params: [AwesomeMediaParamTypes: Any]) {
        self.params = params
    }
    
    public func value(withType type: AwesomeMediaParamTypes) -> Any? {
        return params.filter({ $0.key == type }).first?.value
    }
    
    public var url: URL? {
        guard let value = value(withType: .url) as? String else {
            return nil
        }
        return URL(string: value)
    }
    
    public var coverUrl: URL? {
        guard let value = value(withType: .coverUrl) as? String else {
            return nil
        }
        return URL(string: value)
    }
    
    public var author: String? {
        guard let value = value(withType: .author) as? String else {
            return nil
        }
        return value
    }
    
    public var title: String? {
        guard let value = value(withType: .title) as? String else {
            return nil
        }
        return value
    }
    
    public var duration: Int {
        guard let value = value(withType: .duration) as? Int else {
            return 0
        }
        return value
    }
    
    public var size: String? {
        guard let value = value(withType: .size) as? String else {
            return nil
        }
        return value
    }
    
    public var type: String? {
        guard let value = value(withType: .type) as? String else {
            return nil
        }
        return value
    }
    
    public var id: String? {
        guard let value = value(withType: .id) as? String else {
            return nil
        }
        return value
    }
    
    public var markers: [AwesomeMediaMarker] {
        guard let value = value(withType: .markers) as? [AwesomeMediaMarker] else {
            return []
        }
        return value
    }
}
