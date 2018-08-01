//
//  ACCourseAcademies.swift
//  AwesomeCore-iOS10.0
//
//  Created by Emmanuel on 28/06/2018.
//

import Foundation

public struct ACCourseAcademy: Codable, Equatable {
    
    public let id: Int
    public let domain: String
    public let awcProductId: String?
    
    public init(id: Int,
                domain: String,
                awcProductId: String? = nil
        ) {
        
        self.id = id
        self.domain = domain
        self.awcProductId = awcProductId
    }
    
}

// MARK: - Equatable

extension ACCourseAcademy {
    
    static public func ==(lhs: ACCourseAcademy, rhs: ACCourseAcademy) -> Bool {
        if lhs.id != rhs.id {
            return false
        } else if lhs.domain != rhs.domain {
            return false
        } else if lhs.awcProductId != rhs.awcProductId {
            return false
        }
        return true
    }
    
}
