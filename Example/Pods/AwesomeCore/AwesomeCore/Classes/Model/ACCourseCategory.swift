//
//  ACCourseCategories.swift
//  AwesomeCore-iOS10.0
//
//  Created by Emmanuel on 28/06/2018.
//

import Foundation

public struct ACCourseCategory: Codable, Equatable {
    
    public let id: Int
    public let name: String
    public let ancestorId: String?
    public let ancestorName: String?
    
    public init(id: Int,
                name: String,
                ancestorId: String? = nil,
                ancestorName: String? = nil
        ) {
        
        self.id = id
        self.name = name
        self.ancestorId = ancestorId
        self.ancestorName = ancestorName
    }
    
}

// MARK: - Equatable

extension ACCourseCategory {
    
    static public func ==(lhs: ACCourseCategory, rhs: ACCourseCategory) -> Bool {
        if lhs.id != rhs.id {
            return false
        } else if lhs.name != rhs.name {
            return false
        } else if lhs.ancestorId != rhs.ancestorId {
            return false
        } else if lhs.ancestorName != rhs.ancestorName {
            return false
        }
        return true
    }
    
}
