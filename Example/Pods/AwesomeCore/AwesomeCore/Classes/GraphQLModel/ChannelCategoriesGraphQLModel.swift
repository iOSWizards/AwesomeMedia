//
//  CategoryChannelsGraphQLModel.swift
//  Auth0-iOS10.0
//
//  Created by Maail on 24/05/2019.
//

import Foundation

public struct ChannelCategoriesGraphQLModel {
    
    fileprivate static let categoryModel = "{categories { id name } }"
    
    public static func queryChannelCategories() -> [String: AnyObject] {
        return ["query": String(format: categoryModel, arguments: []) as AnyObject]
    }
    
}
