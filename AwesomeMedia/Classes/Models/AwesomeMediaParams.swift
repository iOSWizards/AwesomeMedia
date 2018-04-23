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
}

public typealias AwesomeMediaParams = [AwesomeMediaParamTypes: Any]

// MARK: - Media Manager Extensions

extension AwesomeMediaManager {

    static func value(forParams params: AwesomeMediaParams, withType type: AwesomeMediaParamTypes) -> Any? {
        return params.filter({ $0.key == type }).first?.value
    }

    static func url(forParams params: AwesomeMediaParams) -> URL? {
        guard let value = value(forParams: params, withType: .url) as? String else {
            return nil
        }
        return URL(string: value)
    }
    
    static func coverUrl(forParams params: AwesomeMediaParams) -> URL? {
        guard let value = value(forParams: params, withType: .coverUrl) as? String else {
            return nil
        }
        return URL(string: value)
    }
    
    static func author(forParams params: AwesomeMediaParams) -> String? {
        guard let value = value(forParams: params, withType: .author) as? String else {
            return nil
        }
        return value
    }
    
    static func title(forParams params: AwesomeMediaParams) -> String? {
        guard let value = value(forParams: params, withType: .title) as? String else {
            return nil
        }
        return value
    }
    
    static func duration(forParams params: AwesomeMediaParams) -> Double {
        guard let value = value(forParams: params, withType: .duration) as? Double else {
            return 0
        }
        return value
    }
    
    static func markers(forParams params: AwesomeMediaParams) -> [AwesomeMediaMarker] {
        guard let value = value(forParams: params, withType: .markers) as? [AwesomeMediaMarker] else {
            return []
        }
        return value
    }
}
