//
//  AwesomeCore+Community.swift
//  Auth0-iOS10.0
//
//  Created by Evandro Harrison Hoffmann on 9/6/18.
//

import Foundation
import RealmSwift

public extension AwesomeCore {
    
    public static func fetchCommunities(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (Communities, ErrorData?) -> Void) {
        CommunityBO.fetchCommunities(params: params, response: response)
    }
    
    public static func fetchCommunities(withProductId productId: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Community], ErrorData?) -> Void) {
        CommunityBO.fetchCommunities(withProductId: productId, params: params, response: response)
    }
    
}
