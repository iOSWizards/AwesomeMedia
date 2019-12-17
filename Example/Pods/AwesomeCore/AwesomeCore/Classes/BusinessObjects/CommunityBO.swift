//
//  CommunityBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 31/01/18.
//

import Foundation
import RealmSwift

public struct CommunityBO {
    
    static var communityNS = CommunityNS.shared
    
    private init() {}
    
    public static func fetchCommunities(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (Communities, ErrorData?) -> Void) {
        
        communityNS.fetchCommunities() { (communities, error) in
            DispatchQueue.main.async {
                response(communities, error)
            }
        }
    }
    
    public static func fetchCommunities(withProductId productId: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Community], ErrorData?) -> Void) {
        
        communityNS.fetchCommunities(withProductId: productId) { (communities, error) in
            DispatchQueue.main.async {
                response(communities, error)
            }
        }
    }
}
