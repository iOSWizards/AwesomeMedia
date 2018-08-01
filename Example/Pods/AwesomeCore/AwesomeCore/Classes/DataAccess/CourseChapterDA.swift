//
//  CourseChapterDA.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 07/08/2017.
//

//import Foundation
//
//class CourseChapterDA {
//    
//    let courseChapterSectionDA = CourseChapterSectionDA()
//    
//    // MARK: - Save
//    
//    func saveSync(_ courseChapter: ACCourseChapter) {
//        _ = parseToCoreData(courseChapter)
//    }
//    
//    // MARK: - Search
//    
//    func loadBy(courseChapterId: Int, courseId: Int, completion: @escaping (ACCourseChapter?) -> Void) {
//        
//        let predicate = NSPredicate(
//            format: "courseChapterId == %d AND course.courseId == %d",
//            courseChapterId, courseId
//        )
//        
//        CDCourseChapter.listAsyncAC(predicate: predicate) { [weak self] (fetch) in
//            guard let courseChapter = fetch?.first as? CDCourseChapter else {
//                completion(nil)
//                return
//            }
//            completion(self?.parseFromCoreData(courseChapter))
//        }
//        
//    }
//    
//    func loadCourseChapterUsingBatch(courseChapterId: Int, courseId: Int, completion: @escaping (ACCourseChapter?) -> Void) {
//        self.loadCDCourseChapterUsingBatch(courseChapterId: courseChapterId, courseId: courseId, completion: { (cdCourseChapter) in
//            guard let cdCourseChapter = cdCourseChapter else {
//                completion(nil); return
//            }
//            completion(self.parseFromCoreData(cdCourseChapter))
//        })
//    }
//    
//    public func loadCDCourseChapterUsingBatch(courseChapterId: Int, courseId: Int, completion: @escaping (CDCourseChapter?) -> Void) {
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            let predicate = NSPredicate(
//                format: "courseChapterId == %d AND course.courseId == %d",
//                courseChapterId, courseId
//            )
//            guard let courseChapter = CDCourseChapter.listAC(predicate: predicate).first as? CDCourseChapter else {
//                completion(nil)
//                return
//            }
//            completion(courseChapter)
//        })
//    }
//    
//    /// Load a CourseChapter based on its courseChapterId and courseId, it will return nil
//    /// in case it can't be found.
//    ///
//    /// - Parameters:
//    ///   - courseChapterId: the courseChapterId
//    ///   - courseId: the courseId
//    /// - Returns: a ACCourseChapter or nil
//    func loadBy(courseChapterId: Int, courseId: Int) -> ACCourseChapter? {
//        
//        let predicate = NSPredicate(
//            format: "courseChapterId == %d AND course.courseId == %d",
//            courseChapterId, courseId
//        )
//        
//        guard let cdCourseChapter = CDCourseChapter.listAC(predicate: predicate).first as? CDCourseChapter else {
//            return nil
//        }
//        
//        return parseFromCoreData(cdCourseChapter)
//    }
//    
//    // MARK: - Parsing
//    
//    func parseToCoreData(_ courseChapter: ACCourseChapter) -> CDCourseChapter {
//        
//        let p = NSPredicate(
//            format: "courseChapterId == %d AND course.courseId == %d",
//            courseChapter.courseChapterId, courseChapter.courseId
//        )
//        
//        let cdCourseChaper = CDCourseChapter.getObjectAC(predicate: p, createIfNil: true) as! CDCourseChapter
//        
//        cdCourseChaper.courseChapterId = Int32( courseChapter.courseChapterId)
//        cdCourseChaper.title = courseChapter.title
//        cdCourseChaper.isCompleted = courseChapter.isCompleted
//        cdCourseChaper.position = Int16(courseChapter.position)
//        cdCourseChaper.courseChapterSections =
//            courseChapterSectionDA.extractCDCourseChapterSections(courseChapter.sections)
//        
//        return cdCourseChaper
//    }
//    
//    func parseToCoreData(_ courseChapter: ACCourseChapter, completion: @escaping (CDCourseChapter?) -> Void) {
//        AwesomeCoreDataAccess.shared.backgroundContext.perform {
//            let p = NSPredicate(
//                format: "courseChapterId == %d AND course.courseId == %d",
//                courseChapter.courseChapterId, courseChapter.courseId
//            )
//            
//            let cdCourseChapter = CDCourseChapter.getObjectAC(predicate: p, createIfNil: true) as! CDCourseChapter
//            
//            cdCourseChapter.courseChapterId = Int32( courseChapter.courseChapterId)
//            cdCourseChapter.title = courseChapter.title
//            cdCourseChapter.isCompleted = courseChapter.isCompleted
//            cdCourseChapter.position = Int16(courseChapter.position)
//            cdCourseChapter.courseChapterSections =
//                self.courseChapterSectionDA.extractCDCourseChapterSections(courseChapter.sections)
//            
//            completion(cdCourseChapter)
//        }
//        
//    }
//    
//    func parseFromCoreData(_ cdCourseChapter: CDCourseChapter) -> ACCourseChapter {
//        return ACCourseChapter(
//            courseChapterId: Int(cdCourseChapter.courseChapterId),
//            title: cdCourseChapter.title ?? "",
//            position: Int(cdCourseChapter.position),
//            isCompleted: cdCourseChapter.isCompleted,
//            sections: courseChapterSectionDA.extractSections(cdCourseChapter.courseChapterSections),
//            courseId: Int(cdCourseChapter.course?.courseId ?? -1)
//        )
//    }
//    
//    func extractCDCourseChapters(_ courseChapters: [ACCourseChapter]) -> NSSet {
//        var courseChapterSet = NSSet()
//        for c in courseChapters {
//            courseChapterSet = courseChapterSet.adding(parseToCoreData(c)) as NSSet
//        }
//        return courseChapterSet
//    }
//    
//    func extractCourseChapters(_ courseChapters: NSSet?) -> [ACCourseChapter] {
//        var arCourseChapters = [ACCourseChapter]()
//        guard let courseChapters = courseChapters else {
//            return arCourseChapters
//        }
//        
//        for c in courseChapters {
//            let cc = parseFromCoreData(c as! CDCourseChapter)
//            arCourseChapters.append(cc)
//        }
//        return arCourseChapters
//    }
//    
//}
