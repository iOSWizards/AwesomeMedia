//
//  ChannelCategory.swift
//  Auth0-iOS10.0
//
//  Created by Maail on 24/05/2019.
//

import Foundation

public struct ChannelCategory: Codable, Equatable {
    
    public var id: String?
    public var name: String?
    
    public init(id: String? = nil, name: String? = nil) {
        self.id = id
        self.name = name
    }
}

public struct ChannelCategories: Codable{
    public let categories: [ChannelCategory]?
}

// MARK: - JSON Key

public struct ChannelCategoriesData: Codable {
    public let data: ChannelCategories?
}

// MARK: - Equatable

extension ChannelCategory {
    public static func ==(lhs: ChannelCategory, rhs: ChannelCategory) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        return true
    }
}


