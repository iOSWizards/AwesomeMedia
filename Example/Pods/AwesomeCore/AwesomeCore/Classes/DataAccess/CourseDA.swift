//
//  CourseDA.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 30/06/17.
//

//import Foundation
//import CoreData
//
//public class CourseDA {
//    
//    public static var shared = CourseDA()
//    
//    let authorDA = AuthorDA()
//    let courseChapterDA = CourseChapterDA()
//    
//    init() {}
//    
//    // MARK: - Save
//    
//    public func saveCourse(_ course: ACCourse, completion: (() -> Void)? = nil) {
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            _ = self.parseToCoreData(course)
//        }, operationDone: {
//            completion?()
//        })
//    }
//    
//    func saveCourses(_ courses: [ACCourse]) {
//        for course in courses {
//            saveCourse(course)
//        }
//    }
//    
//    // MARK: - Search
//    
//    func loadBy(courseId: Int) -> CDCourse? {
//        let predicate = NSPredicate(format: "courseId == %d", courseId)
//        guard let cdCourse = CDCourse.listAC(predicate: predicate).first as? CDCourse else {
//            return nil
//        }
//        return cdCourse
//    }
//    
//    func loadCourseUsingBatch(courseId: Int, completion: @escaping (ACCourse?) -> Void) {
//        self.loadCDCourseUsingBatch(courseId: courseId, completion: { (cdCourse) in
//            guard let cdCourse = cdCourse else {
//                completion(nil); return
//            }
//            completion(self.parseFromCoreData(cdCourse))
//        })
//    }
//    
//    public func loadCDCourseUsingBatch(courseId: Int, completion: @escaping (CDCourse?) -> Void) {
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            let predicate = NSPredicate(format: "courseId == %d", courseId)
//            guard let course = CDCourse.listAC(predicate: predicate).first as? CDCourse else {
//                completion(nil)
//                return
//            }
//            completion(course)
//        })
//    }
//    
//    public func loadAllUsingBatch(completion: @escaping ([ACCourse]) -> Void){
//        AwesomeCoreDataAccess.shared.performInBackground({
//            var courses = [ACCourse]()
//            if let cdCourses = CDCourse.listAC() as? [CDCourse], !cdCourses.isEmpty {
//                for cdCourse in cdCourses {
//                    if let course = self.parseFromCoreData(cdCourse) {
//                        courses.append(course)
//                    }
//                }
//                completion(courses)
//                return
//            }
//            completion(courses)
//        })
//    }
//    
//    // MARK: - Parsing
//    
//    func parseToCoreData(_ course: ACCourse) -> CDCourse {
//        
//        var cdCourse: CDCourse? = loadBy(courseId: course.courseId)
//        
//        if cdCourse == nil {
//            cdCourse = CDCourse.newInstanceAC() as? CDCourse
//        }
//        
//        cdCourse?.courseId = Int32(course.courseId)
//        cdCourse?.title = course.title
//        cdCourse?.slug = course.slug
//        cdCourse?.mainColor = course.mainColor
//        cdCourse?.courseUrl = course.courseUrl
//        cdCourse?.coverImageUrl = course.coverImageUrl
//        cdCourse?.lastReadChapter = Int32(course.lastReadChapter)
//        cdCourse?.isCompleted = course.isCompleted
//        cdCourse?.academyId = Int32(course.academyId)
//        cdCourse?.awcProductId = Int32(course.awcProductId ?? 0)
//        cdCourse?.completionPercentage = course.completionProgress?.completionPercentage ?? 0.0
//        cdCourse?.totalChapters = Int16(course.completionProgress?.totalChapters ?? 0)
//        cdCourse?.numberOfChaptersRead = Int16(course.completionProgress?.chaptersRead ?? 0)
//        cdCourse?.authors = authorDA.extractAuthors(course.authors)
//        cdCourse?.courseChapters = courseChapterDA.extractCDCourseChapters(course.courseChapters)
//        cdCourse?.averageRating = Int16(course.averageRating ?? 0)
//        cdCourse?.npsScore = Int16(course.npsScore ?? 0)
//        cdCourse?.publishedAt = HelperDA.castToNSDate(course.publishedAt)
//        cdCourse?.lastUpdatedAt = HelperDA.castToNSDate(course.lastUpdatedAt)
//        cdCourse?.enrolledOn = HelperDA.castToNSDate(course.enrolledOn)
//        cdCourse?.purchasedAt = HelperDA.castToNSDate(course.purchasedAt)
//        
//        return cdCourse!
//    }
//    
//    func parseToCoreData(_ course: ACCourse, completion: @escaping (CDCourse?) -> Void) {
//        AwesomeCoreDataAccess.shared.backgroundContext.perform {
//            
//            var cdCourse: CDCourse? = self.loadBy(courseId: course.courseId)
//            
//            if cdCourse == nil {
//                cdCourse = CDCourse.newInstanceAC() as? CDCourse
//            }
//            
//            cdCourse?.courseId = Int32(course.courseId)
//            cdCourse?.title = course.title
//            cdCourse?.slug = course.slug
//            cdCourse?.mainColor = course.mainColor
//            cdCourse?.courseUrl = course.courseUrl
//            cdCourse?.coverImageUrl = course.coverImageUrl
//            cdCourse?.lastReadChapter = Int32(course.lastReadChapter)
//            cdCourse?.isCompleted = course.isCompleted
//            cdCourse?.academyId = Int32(course.academyId)
//            cdCourse?.awcProductId = Int32(course.awcProductId ?? 0)
//            cdCourse?.completionPercentage = course.completionProgress?.completionPercentage ?? 0.0
//            cdCourse?.totalChapters = Int16(course.completionProgress?.totalChapters ?? 0)
//            cdCourse?.numberOfChaptersRead = Int16(course.completionProgress?.chaptersRead ?? 0)
//            cdCourse?.authors = self.authorDA.extractAuthors(course.authors)
//            cdCourse?.courseChapters = self.courseChapterDA.extractCDCourseChapters(course.courseChapters)
//            cdCourse?.averageRating = Int16(course.averageRating ?? 0)
//            cdCourse?.npsScore = Int16(course.npsScore ?? 0)
//            cdCourse?.publishedAt = HelperDA.castToNSDate(course.publishedAt)
//            cdCourse?.lastUpdatedAt = HelperDA.castToNSDate(course.lastUpdatedAt)
//            cdCourse?.enrolledOn = HelperDA.castToNSDate(course.enrolledOn)
//            cdCourse?.purchasedAt = HelperDA.castToNSDate(course.purchasedAt)
//            
//            completion(cdCourse)
//        }
//        
//    }
//    
//    func parseFromCoreData(_ course: CDCourse) -> ACCourse? {
//        
//        var completionProgress: CompletionProgress?
//        if !(course.totalChapters == 0 && course.numberOfChaptersRead == 0 && course.completionPercentage == 0) {
//            completionProgress = CompletionProgress(
//                totalChapters: Int(course.totalChapters),
//                chaptersRead: Int(course.numberOfChaptersRead),
//                completionPercentage: course.completionPercentage
//            )
//        }
//        
//        return ACCourse(
//            courseId: Int(course.courseId),
//            title: course.title ?? "",
//            slug: course.slug ?? "",
//            mainColor: course.mainColor ?? "",
//            courseUrl: course.courseUrl ?? "",
//            coverImageUrl: course.coverImageUrl ?? "",
//            lastReadChapter: Int(course.lastReadChapter),
//            isCompleted: course.isCompleted,
//            academyId: Int(course.academyId),
//            awcProductId: Int(course.awcProductId),
//            completionProgress: completionProgress,
//            authors: authorDA.extractCDAuthors(course.authors),
//            courseChapters: courseChapterDA.extractCourseChapters(course.courseChapters),
//            averageRating: Int(course.averageRating),
//            npsScore: Int(course.npsScore),
//            publishedAt: course.publishedAt as Date? ?? nil,
//            lastUpdatedAt: course.lastUpdatedAt  as Date? ?? nil,
//            enrolledOn: course.enrolledOn as Date? ?? nil,
//            purchasedAt: course.purchasedAt as Date? ?? nil
//        )
//    }
//    
//    // MARK: - Delete
//    
//    func deleteAll() {
//        CDCourse.deleteAllUsingBackgroundContext()
//    }
//    
//}

