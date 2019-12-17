//
//  ForceUpdateGraphQLModel.swift
//  AwesomeCore
//
//  Created by Maail on 03/04/2019.
//

import Foundation

public struct ForceUpdateGraphQLModel {
    
    fileprivate static let forceUpdateModel = "{ app { settings { latestVersion lastStableVersion updateMessage } } }"
    
    public static func queryForceUpdate() -> [String: AnyObject] {
        return ["query": String(format: forceUpdateModel, arguments: []) as AnyObject]
    }
    
}
