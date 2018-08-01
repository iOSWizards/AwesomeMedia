//
//  CourseMP.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 04/07/2017.
//

import Foundation

public struct CourseMP {
    
    private init() {
        
    }
    
    /// Parses a JSON documento to a Course object.
    ///
    /// - Parameter jsonObject: JSON document as [String: AnyObject]
    /// - Returns: Course object.
    public static func parseCourseFrom(jsonObject: [String: AnyObject]) -> ACCourse? {
        guard let courseJSON = jsonObject["course"] as? [String: AnyObject] else {
            return nil
        }
        return extractCourse(courseJSON)
    }
    
    public static func parseCoursesFrom(jsonObject: [String: AnyObject]) ->[ACCourse] {
        var courses = [ACCourse]()
        
        guard let coursesDict = jsonObject["courses"] as? [[String: AnyObject]] else {
            return courses
        }
        
        for courseDict in coursesDict {
            if let c = extractCourse(courseDict) {
                courses.append(c)
            }
        }
        
        return courses
    }
    
    static func extractCourse(_ courseJSON: [String: AnyObject]) -> ACCourse? {
        
        var completion: CompletionProgress?
        if let completionProgress = courseJSON["completion_progress"] as? [String: AnyObject] {
            completion = CompletionProgressMP.parseCompletionProgressFrom(jsonObject: completionProgress)
        }
        
        var courseChapters: [ACCourseChapter] = []
        if let jsonArray = courseJSON["chapters"] as? [[String: AnyObject]] {
            for object in jsonArray {
                if let chapter = CourseChapterMP.parseCourseChapterFrom(jsonObject: object) {
                    courseChapters.append(chapter)
                }
            }
        }
        
        return ACCourse(
            courseId: AwesomeCoreParser.intValue(courseJSON, key: "id"),
            title: ParserCoreHelper.parseString(courseJSON, key: "title"),
            slug: ParserCoreHelper.parseString(courseJSON, key: "slug"),
            mainColor: ParserCoreHelper.parseString(courseJSON, key: "main_color"),
            courseUrl: ParserCoreHelper.parseString(courseJSON, key: "course_url"),
            coverImageUrl: ParserCoreHelper.parseString(courseJSON, key: "cover_image_url"),
            lastReadChapter: AwesomeCoreParser.intValue(courseJSON, key: "last_read_chapter"),
            isCompleted: ParserCoreHelper.parseBool(courseJSON, key: "is_completed") as! Bool,
            academyId: AwesomeCoreParser.intValue(courseJSON, key: "academy_id"),
            awcProductId: AwesomeCoreParser.intValue(courseJSON, key: "awc_product_id"),
            completionProgress: completion,
            authors: AuthorMP.parseAuthorsFrom(jsonObject: courseJSON, key: "authors"),
            courseChapters: courseChapters,
            academies: CourseAcademyMP.parseCourseAcademiesFrom(jsonObject: courseJSON, key: "academies"),
            categories: CourseCategoryMP.parseCourseCategoriesFrom(jsonObject: courseJSON, key: "categories"),
            averageRating: AwesomeCoreParser.intValue(courseJSON, key: "average_rating"),
            npsScore: AwesomeCoreParser.intValue(courseJSON, key: "nps_score"),
            publishedAt: ParserCoreHelper.parseDate(dateString: ParserCoreHelper.parseString(courseJSON, key: "published_at")),
            lastUpdatedAt: ParserCoreHelper.parseDate(dateString: ParserCoreHelper.parseString(courseJSON, key: "last_updated_at")),
            enrolledOn: ParserCoreHelper.parseDate(dateString: ParserCoreHelper.parseString(courseJSON, key: "enrolled_on")),
            purchasedAt: ParserCoreHelper.parseDate(dateString: ParserCoreHelper.parseString(courseJSON, key: "purchased_at"))
        )
    }
    
}
