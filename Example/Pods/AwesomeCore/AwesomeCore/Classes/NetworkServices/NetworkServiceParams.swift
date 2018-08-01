//
//  NetworkServiceParams.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 5/11/18.
//

import Foundation

public struct AwesomeCoreNetworkServiceParams: OptionSet {
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public static let canCancelRequest = AwesomeCoreNetworkServiceParams(rawValue: 1 << 0)
    public static let shouldFetchFromCache = AwesomeCoreNetworkServiceParams(rawValue: 1 << 1)
    
    public static let standard: AwesomeCoreNetworkServiceParams = [.canCancelRequest, .shouldFetchFromCache]
    public static let forcing: AwesomeCoreNetworkServiceParams = []
}
