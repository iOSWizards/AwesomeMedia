//
//  AwesomeTrackingDictionary.swift
//  AwesomeTracking
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/06/18.
//

import Foundation

public class AwesomeTrackingDictionary: ExpressibleByDictionaryLiteral {
    
    public typealias Key = AwesomeTrackingParams
    public typealias Value = Any
    
    private var dict: [String: Any] = [:]
    private var aliasDict: [AwesomeTrackingParams: Any] = [:]
    
    public required init(dictionaryLiteral elements: (AwesomeTrackingParams, Any)...) {
        for (param, valueForParam) in elements {
            dict[param.rawValue] = valueForParam
        }
    }
    
    public func addElement(_ element: Any, forKey: AwesomeTrackingParams) {
        aliasDict[forKey] = element
    }
    
    public func stringLiteral() -> [String: Any] {
        if aliasDict.count > 0 {
            for (param, valueForParam) in aliasDict {
                dict[param.rawValue] = valueForParam
            }
        }
        return dict
    }
    
}
