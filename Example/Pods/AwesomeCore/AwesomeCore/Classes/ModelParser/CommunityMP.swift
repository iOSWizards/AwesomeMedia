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
        do {
            let decoded = try JSONDecoder().decode(CommunityRootData.self, from: communitiesJSON)
            return self.sortCommunities(data: decoded.data)
        } catch {
            print("\(#function) error: \(error)")
            return CommunityData(communities: Communities(publicGroups: [], tribeMembership: [], privateGroups: []))
        }
    }
    
    static func sortCommunities(data: CommunityListData) -> CommunityData {
        var publicGroups: [Community] = []
        var privateGroups: [Community] = []
        var tribeMembership: [Community] = []
        for community in data.communities {
            if community.type == "public"{
                publicGroups.append(community)
            } else if community.type == "private" {
                var tribeProductID = "1016"
                if AwesomeCore.shared.prodEnvironment == false {
                    tribeProductID = "123"
                }
                if community.productIds?.contains(tribeProductID) ?? false {
                    tribeMembership.append(community)
                } else {
                   privateGroups.append(community)
                }
            }
        }
        return CommunityData(communities: Communities(publicGroups: publicGroups, tribeMembership: tribeMembership, privateGroups: privateGroups))
    }
    
    static func parseCommunityListFrom(_ communitiesJSON: Data) -> [Community] {
        if let decoded = try? JSONDecoder().decode(CommunityListData.self, from: communitiesJSON) {
            return decoded.communities
        } else {
            return []
        }
    }
    
}
