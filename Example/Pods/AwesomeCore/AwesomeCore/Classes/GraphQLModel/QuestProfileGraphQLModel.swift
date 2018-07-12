//
//  QuestProfileGraphQLModel.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 3/7/18.
//

import Foundation

public struct QuestProfileGraphQLModel {
    
    // MARK: - Profile Query
    
    private static let profileModel = "query { profile { id uid lastName firstName email dateOfBirth avatarUrl uid country dateOfBirth lang location role timezone } }"
    
    public static func queryProfile() -> [String: AnyObject] {
        return ["query": profileModel as AnyObject]
    }
    
    // MARK: - Update profile Mutation
    
    private static let mutateUpdateProfile = "mutation { updateProfile(email: \"%@\", firstName: \"%@\", lastName: \"%@\") { lastName firstName email } }"
    
    public static func mutateUpdateProfile(_ email: String, firstName: String, lastname: String) -> [String: AnyObject] {
        return ["query": String(format: mutateUpdateProfile, arguments: [email, firstName, lastname]) as AnyObject]
    }
}
