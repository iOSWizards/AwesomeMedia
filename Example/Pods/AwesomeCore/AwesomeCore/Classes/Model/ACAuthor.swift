//
//  Author.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 10/07/17.
//

import Foundation

public struct ACAuthor: Codable, Equatable {
    
    public let authorId: Int
    public let name: String
    public let assetCoverUrl: String?
    public let academyId: Int
    
    public init(authorId: Int,
         name: String,
         assetCoverUrl: String? = nil,
         academyId: Int = -1
        ) {
        
        self.authorId = authorId
        self.name = name
        self.assetCoverUrl = assetCoverUrl
        self.academyId = academyId
    }
    
}

// MARK: - Equatable

extension ACAuthor {
    
    static public func ==(lhs: ACAuthor, rhs: ACAuthor) -> Bool {
        if lhs.authorId != rhs.authorId {
            return false
        } else if lhs.name != rhs.name {
            return false
        } else if lhs.assetCoverUrl != rhs.assetCoverUrl {
            return false
        } else if lhs.academyId != rhs.academyId {
            return false
        }
        return true
    }
    
}
