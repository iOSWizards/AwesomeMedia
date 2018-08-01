//
//  FreeEpisodes.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 29/03/18.
//

import Foundation

public struct FreeCourses: Codable {
    public let courses: [FreeCourse]
}

public struct FreeCourse: Codable {
    
    public let coverUrl: String
    public let productId: Int
    public let academyId: Int
    public let courseId: Int
    public let date: String
    public let title: String
    public let author: String
    public let placeholder: String
    public let categories: [String]
    public let href: String
    public let studentCount: Int
    public let rating: Double
    
}

// MARK: - Coding keys

extension FreeCourse {
    private enum CodingKeys: String, CodingKey {
        case coverUrl = "image_url"
        case productId = "awc_product_id"
        case academyId = "academy_id"
        case courseId = "course_id"
        case date
        case title
        case author
        case placeholder
        case categories
        case href
        case studentCount = "student_count"
        case rating
    }
}

extension FreeCourses {
    private enum CodingKeys: String, CodingKey {
        case courses = "mtm_courses"
    }
}

// MARK: - Equatable

extension FreeCourses {
    public static func ==(lhs: FreeCourses, rhs: FreeCourses) -> Bool {
        if lhs.courses.first?.productId != rhs.courses.first?.productId  {
            return false
        }
        return true
    }
}
