//
//  CourseChapter.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 10/07/17.
//

import Foundation

public struct ACCourseChapter: Codable, Equatable {
    
    public let courseChapterId: Int
    public let title: String
    public let position: Int
    public var isCompleted: Bool
    public var sections: [Section]
    public let courseId: Int
    
    public init(courseChapterId: Int,
         title: String,
         position: Int,
         isCompleted: Bool,
         sections: [Section],
         courseId: Int = -1) {
        
        self.courseChapterId = courseChapterId
        self.title = title
        self.position = position
        self.isCompleted = isCompleted
        self.sections = sections
        self.courseId = courseId
        
    }
    
}

// MARK: - Equatable

extension ACCourseChapter {
    
    static public func ==(lhs: ACCourseChapter, rhs: ACCourseChapter) -> Bool {
        if lhs.courseChapterId != rhs.courseChapterId {
            return false
        } else if lhs.title != rhs.title {
            return false
        } else if lhs.position != rhs.position {
            return false
        } else if lhs.isCompleted != rhs.isCompleted {
            return false
        } else if lhs.courseId != rhs.courseId {
            return false
        }
        return true
    }
    
}
