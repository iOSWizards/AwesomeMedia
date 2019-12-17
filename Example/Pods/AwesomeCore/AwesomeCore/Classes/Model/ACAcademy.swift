//
//  ACAcademy.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 29/08/2017.
//

import Foundation

public struct ACAcademy: Equatable {
    
    public let id: Int
    public let domain: String
    public let name: String
    public let type: String
    public let subscription: Bool
    public let awcProductId: String
    public let themeColor: String
    public let tribeLearnTribeId: String
    public let courseOrdering: String
    public let authors: [ACAuthor]
    public let numberOfCourses: Int
    public let featuredCourseId: Int
    public let coverPhotoURL: String
    public let courseCoverImages: [String]
    public let purchased: Bool
    public let purchasedAt: Date?
    
    public init(id: Int,
         domain: String,
         name:String,
         type: String,
         subscription: Bool,
         awcProductId: String,
         themeColor:String,
         tribeLearnTribeId: String,
         courseOrdering: String,
         authors: [ACAuthor],
         numberOfCourses: Int,
         featuredCourseId: Int,
         coverPhotoURL: String,
         courseCoverImages: [String],
         purchased: Bool,
         purchasedAt: Date?) {
        
        self.id = id
        self.domain = domain
        self.name = name
        self.type = type
        self.subscription = subscription
        self.awcProductId = awcProductId
        self.themeColor = themeColor
        self.tribeLearnTribeId = tribeLearnTribeId
        self.courseOrdering = courseOrdering
        self.authors = authors.sorted(by: {$0.name < $1.name})
        self.numberOfCourses = numberOfCourses
        self.featuredCourseId = featuredCourseId
        self.coverPhotoURL = coverPhotoURL
        self.courseCoverImages = courseCoverImages.sorted(by: { $0 < $1 })
        self.purchased = purchased
        self.purchasedAt = purchasedAt
    }

}

// MARK: - Equatable

extension ACAcademy {
    public static func ==(lhs: ACAcademy, rhs: ACAcademy) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.domain != rhs.domain {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if lhs.type != rhs.type {
            return false
        }
        if lhs.subscription != rhs.subscription {
            return false
        }
        if lhs.awcProductId != rhs.awcProductId {
            return false
        }
        if lhs.themeColor != rhs.themeColor {
            return false
        }
        if lhs.tribeLearnTribeId != rhs.tribeLearnTribeId {
            return false
        }
        if lhs.courseOrdering != rhs.courseOrdering {
            return false
        }
        if lhs.authors != rhs.authors {
            return false
        }
        if lhs.numberOfCourses != rhs.numberOfCourses {
            return false
        }
        if lhs.featuredCourseId != rhs.featuredCourseId {
            return false
        }
        if lhs.coverPhotoURL != rhs.coverPhotoURL {
            return false
        }
        if lhs.courseCoverImages != rhs.courseCoverImages {
            return false
        }
        if lhs.purchased != rhs.purchased {
            return false
        }
        if lhs.purchasedAt != rhs.purchasedAt {
            return false
        }
        return true
    }
}
