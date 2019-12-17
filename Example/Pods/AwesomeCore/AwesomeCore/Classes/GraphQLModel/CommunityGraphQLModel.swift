//
//  CommunityGraphQLModel.swift
//  AwesomeCore
//
//  Created by Maail on 01/05/2019.
//

import Foundation

public struct CommunityGraphQLModel {
    
    fileprivate static let communityModel = "{communities {description groupId productIds id name passphrase type url backgroundAsset{url}} }"
    
    public static func queryCommunities() -> [String: AnyObject] {
        return ["query": String(format: communityModel, arguments: []) as AnyObject]
    }
    
}
