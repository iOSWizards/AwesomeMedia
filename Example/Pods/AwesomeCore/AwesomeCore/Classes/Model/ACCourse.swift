//
//  Course.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 30/06/17.
//

import Foundation

public struct ACCourse: Codable, Equatable {
    
    public let courseId: Int
    public let title: String
    public let slug: String
    public let awcProductId: Int?
    public let mainColor: String
    public let courseUrl: String
    public let coverImageUrl: String
    public let lastReadChapter: Int
    public var isCompleted: Bool
    public let academyId: Int
    public let authors: [ACAuthor]
    public let courseChapters: [ACCourseChapter]
    public let academies: [ACCourseAcademy]
    public let categories: [ACCourseCategory]
    public var completionProgress: CompletionProgress?
    public let averageRating: Int?
    public let npsScore: Int?
    public let publishedAt: Date?
    public let lastUpdatedAt: Date?
    public let enrolledOn: Date?
    public let purchasedAt: Date?
    
    public init(courseId: Int,
         title: String,
         slug: String,
         mainColor: String,
         courseUrl: String,
         coverImageUrl: String,
         lastReadChapter: Int,
         isCompleted: Bool,
         academyId: Int,
         awcProductId: Int? = nil,
         completionProgress: CompletionProgress?,
         authors: [ACAuthor],
         courseChapters: [ACCourseChapter],
         academies: [ACCourseAcademy],
         categories: [ACCourseCategory],
         averageRating: Int? = nil,
         npsScore: Int? = nil,
         publishedAt: Date? = nil,
         lastUpdatedAt: Date? = nil,
         enrolledOn: Date? = nil,
         purchasedAt: Date? = nil) {
        
        self.courseId = courseId
        self.title = title
        self.slug = slug
        self.awcProductId = awcProductId
        self.mainColor = mainColor
        self.courseUrl = courseUrl
        self.coverImageUrl = coverImageUrl
        self.lastReadChapter = lastReadChapter
        self.isCompleted = isCompleted
        self.academyId = academyId
        self.completionProgress = completionProgress
        self.authors = authors
        self.courseChapters = courseChapters
        self.academies = academies
        self.categories = categories
        self.averageRating = averageRating
        self.npsScore = npsScore
        self.publishedAt = publishedAt
        self.lastUpdatedAt = lastUpdatedAt
        self.enrolledOn = enrolledOn
        self.purchasedAt = purchasedAt
        
    }
    
    // MARK: - Computed Properties
    
    public var currentChapter: ACCourseChapter? {
        for chapter in courseChapters where chapter.courseChapterId == lastReadChapter {
            return chapter
        }
        return nil
    }
    
    public var orderedChapters: [ACCourseChapter] {
        return courseChapters.sorted(by: { (chapter1, chapter2) -> Bool in
            chapter1.position < chapter2.position
        })
    }
    
    public var totalSectionsDuration: String {
        var total = 0
        for ch in courseChapters {
            for sec in ch.sections {
                total += sec.duration ?? 0
            }
        }
        return total.secondsToTimeString
    }
    
    // MARK: - Functions
    
    public func previewsChapter(withChapter currentChapter: ACCourseChapter) -> ACCourseChapter? {
        if let index = orderedChapters.index(of: currentChapter), index > 0 {
            let indexBefore = orderedChapters.index(before: index)
            return orderedChapters[indexBefore]
        }
        return nil
    }
    
    public func nextChapter(withChapter currentChapter: ACCourseChapter) ->ACCourseChapter? {
        if let index = orderedChapters.index(of: currentChapter), (index + 1) < orderedChapters.count {
            let indexAfter = orderedChapters.index(after: index)
            return orderedChapters[indexAfter]
        }
        return nil
    }
}

// MARK: - Equatable

extension ACCourse {
    static public func ==(lhs: ACCourse, rhs: ACCourse) -> Bool {
        if lhs.courseId != rhs.courseId {
            return false
        }
        if lhs.title != rhs.title {
            return false
        }
        if lhs.slug != rhs.slug {
            return false
        }
        if lhs.mainColor != rhs.mainColor {
            return false
        }
        if lhs.courseUrl != rhs.courseUrl {
            return false
        }
        if lhs.coverImageUrl != rhs.coverImageUrl {
            return false
        }
        if lhs.lastReadChapter != rhs.lastReadChapter {
            return false
        }
        if lhs.isCompleted != rhs.isCompleted {
            return false
        }
        if lhs.academyId != rhs.academyId {
            return false
        }
        if lhs.completionProgress != rhs.completionProgress {
            return false
        }
        if lhs.authors != rhs.authors {
            return false
        }
        if lhs.courseChapters != rhs.courseChapters {
            return false
        }
        if lhs.academies != rhs.academies {
            return false
        }
        if lhs.categories != rhs.categories {
            return false
        }
        if lhs.averageRating != rhs.averageRating {
            return false
        }
        if lhs.npsScore != rhs.npsScore {
            return false
        }
        if lhs.publishedAt != rhs.publishedAt {
            return false
        }
        if lhs.lastUpdatedAt != rhs.lastUpdatedAt {
            return false
        }
        if lhs.enrolledOn != rhs.enrolledOn {
            return false
        }
        if lhs.purchasedAt != rhs.purchasedAt {
            return false
        }
        return true
    }
}

