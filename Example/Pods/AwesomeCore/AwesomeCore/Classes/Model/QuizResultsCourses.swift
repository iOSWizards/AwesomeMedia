//
//  QuizResultsCourses.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/03/18.
//

import Foundation

public struct QuizResultsCourses: Codable {
    public let courses: [QuizCourses]
}

public struct QuizCourses: Codable {
    
    public let coverUrl: String
    public let description: String
    public let courseUrl: String
    public let productId: Int?
    public let academyId: Int?
    public let courseId: Int?
    
    init(coverUrl: String,
         description: String,
         courseUrl: String,
         productId: Int?,
         academyId: Int? = nil,
         courseId: Int? = nil) {
        
        self.coverUrl = coverUrl
        self.description = description
        self.courseUrl = courseUrl
        self.productId = productId
        self.academyId = academyId
        self.courseId = courseId
    }
    
}

// MARK: - Coding keys

extension QuizCourses {
    private enum CodingKeys: String, CodingKey {
        case coverUrl
        case description
        case courseUrl
        case productId
        case academyId = "academy_id"
        case courseId = "course_id"
    }
}

// MARK: - Equatable

extension QuizResultsCourses {
    public static func ==(lhs: QuizResultsCourses, rhs: QuizResultsCourses) -> Bool {
        if lhs.courses.first?.productId != rhs.courses.first?.productId  {
            return false
        }
        return true
    }
}
