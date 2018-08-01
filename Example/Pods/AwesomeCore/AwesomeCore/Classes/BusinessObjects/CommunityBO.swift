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
    
    public static func fetchCommunities(forcingUpdate: Bool = false, response: @escaping (Communities, ErrorData?) -> Void) {
        
        communityNS.fetchCommunities(forcingUpdate: forcingUpdate) { (communities, error) in
            DispatchQueue.main.async {
                
                response(communities, error)
            }
        }
    }
}
