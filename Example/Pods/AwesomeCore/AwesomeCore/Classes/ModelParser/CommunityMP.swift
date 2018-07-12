//
//  CommunityMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 31/01/18.
//

import Foundation
import Realm
import RealmSwift

struct CommunityMP {
    
    static func parseCommunitiesFrom(_ communitiesJSON: Data) -> CommunityData {
        
        if let decoded = try? JSONDecoder().decode(CommunityData.self, from: communitiesJSON) {
            return decoded
        } else {
            return CommunityData(communities: Communities(publicGroups: [], tribeMembership: [], privateGroups: []))
        }
    }
    
}
