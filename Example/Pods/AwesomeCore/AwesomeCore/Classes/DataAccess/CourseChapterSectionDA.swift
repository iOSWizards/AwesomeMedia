//
//  CourseChapterDA.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 02/08/17.
//

//import Foundation
//
//class CourseChapterSectionDA {
//
//    func saveSync(_ section: Section) {
//        _ = parseToCoreData(section)
//    }
//
//    func saveSync(_ section: Section, completion: @escaping () -> Void) {
//        parseToCoreData(section) { (_) in
//            completion()
//        }
//    }
//
//    func saveSyncNonCourse(_ section: Section) {
//        _ = parseToCoreData(section)
//    }
//
//    func fetchSyncSection(withSection section: Section, courseId: Int, chapterId: Int) -> Section? {
//        let p = NSPredicate(
//            format: "courseChapterSectionId == %d AND courseChapter.courseChapterId == %d AND "
//                + " courseChapter.course.courseId == %d",
//            section.courseChapterSectionId, chapterId, courseId
//        )
//
//        if let cdSection = CDCourseChapterSection.getObjectAC(withContext: AwesomeCoreDataAccess.shared.backgroundContext, predicate: p) as? CDCourseChapterSection  {
//            return parseFromCoreData(cdSection)
//        }
//        return nil
//    }
//
//    /// Parse a Marker (Domain Object) to our Core Data object.
//    ///
//    /// - Parameter marker: cdMarker: a Marker object.
//    /// - Returns: a CDSectionMarker object containing all data present on the Marker object.
//    func parseToCoreData(_ section: Section) -> CDCourseChapterSection {
//
//        let p = NSPredicate(
//            format: "courseChapterSectionId == %d AND courseChapter.courseChapterId == %d AND "
//                + " courseChapter.course.courseId == %d",
//            section.courseChapterSectionId, section.courseChapterId, section.courseId
//        )
//
//        let cdSection = CDCourseChapterSection.getObjectAC(predicate: p, createIfNil: true) as! CDCourseChapterSection
//
//        let time = cdSection.continueAtTime
//        cdSection.courseChapterSectionId = Int32(section.courseChapterSectionId)
//        cdSection.title = section.title
//        cdSection.type = section.type
//        cdSection.position = Int16(section.position)
//        cdSection.body = section.body
//        cdSection.mode = section.mode
//        cdSection.duration = Double(section.duration ?? 0)
//        if section.continueAtTime ?? 0.0 > 0.0 {
//            cdSection.continueAtTime = section.continueAtTime ?? 0
//        } else {
//            cdSection.continueAtTime = time
//        }
//        cdSection.downloadable = section.downloadable ?? false
//        cdSection.embedCode = section.embedCode
//        cdSection.imageLink = section.imageLink
//        cdSection.assetCoverUrl = section.assetCoverUrl
//        cdSection.assetUrl = section.assetUrl
//        cdSection.assetSize = Double(section.assetSize ?? 0)
//        cdSection.assetFileExtension = section.assetFileExtension
//        cdSection.assetStreamingUrl = section.assetStreamingUrl
//        cdSection.courseChapterSectionMarkers = SectionMarkerDA().extractCDSectionMarkers(section.markers)
//
//        return cdSection
//    }
//
//    func parseToCoreData(_ section: Section, completion: @escaping (CDCourseChapterSection?) -> Void) {
//        AwesomeCoreDataAccess.shared.backgroundContext.perform {
//            let p = NSPredicate(
//                format: "courseChapterSectionId == %d AND courseChapter.courseChapterId == %d AND "
//                    + " courseChapter.course.courseId == %d",
//                section.courseChapterSectionId, section.courseChapterId, section.courseId
//            )
//
//            let cdSection = CDCourseChapterSection.getObjectAC(predicate: p, createIfNil: true) as! CDCourseChapterSection
//
//            let time = cdSection.continueAtTime
//            cdSection.courseChapterSectionId = Int32(section.courseChapterSectionId)
//            cdSection.title = section.title
//            cdSection.type = section.type
//            cdSection.position = Int16(section.position)
//            cdSection.body = section.body
//            cdSection.mode = section.mode
//            cdSection.duration = Double(section.duration ?? 0)
//            if section.continueAtTime ?? 0.0 > 0.0 {
//                cdSection.continueAtTime = section.continueAtTime ?? 0
//            } else {
//                cdSection.continueAtTime = time
//            }
//            cdSection.downloadable = section.downloadable ?? false
//            cdSection.embedCode = section.embedCode
//            cdSection.imageLink = section.imageLink
//            cdSection.assetCoverUrl = section.assetCoverUrl
//            cdSection.assetUrl = section.assetUrl
//            cdSection.assetSize = Double(section.assetSize ?? 0)
//            cdSection.assetFileExtension = section.assetFileExtension
//            cdSection.assetStreamingUrl = section.assetStreamingUrl
//            cdSection.courseChapterSectionMarkers = SectionMarkerDA().extractCDSectionMarkers(section.markers)
//
//            completion(cdSection)
//        }
//
//    }
//
//    /// Parse a CDSectionMarker (CoreData Object) to our domain model Marker.
//    ///
//    /// - Parameter cdMarker: a CDSectionMarker object.
//    /// - Returns: a Marker object containing all data present on the CDSectionMarker.
//    func parseFromCoreData(_ cdCourseSection: CDCourseChapterSection) -> Section {
//        return Section(
//            courseChapterSectionId: Int(cdCourseSection.courseChapterSectionId),
//            title: cdCourseSection.title ?? "",
//            type: cdCourseSection.type ?? "",
//            markers: SectionMarkerDA().extractSectionMarkers(cdCourseSection.courseChapterSectionMarkers),
//            position: Int(cdCourseSection.position),
//            body: cdCourseSection.body,
//            mode: cdCourseSection.mode,
//            duration: Int(cdCourseSection.duration),
//            continueAtTime: cdCourseSection.continueAtTime,
//            downloadable:  cdCourseSection.downloadable,
//            embedCode: cdCourseSection.embedCode,
//            imageLink: cdCourseSection.imageLink,
//            assetCoverUrl: cdCourseSection.assetCoverUrl,
//            assetUrl: cdCourseSection.assetUrl,
//            assetSize: Int(cdCourseSection.assetSize),
//            assetFileExtension: cdCourseSection.assetFileExtension,
//            assetStreamingUrl: cdCourseSection.assetStreamingUrl,
//            courseChapterId: Int(cdCourseSection.courseChapter?.courseChapterId ?? -1),
//            courseId: Int(cdCourseSection.courseChapter?.course?.courseId ?? -1)
//        )
//    }
//
//    func extractCDCourseChapterSections(_ sections: [Section]) -> NSSet {
//        var sectionsSet = NSSet()
//        for section in sections {
//            sectionsSet = sectionsSet.adding(parseToCoreData(section)) as NSSet
//        }
//        return sectionsSet
//    }
//
//    func extractSections(_ sections: NSSet?) -> [Section] {
//        var arSections = [Section]()
//        guard let sections = sections else {
//            return arSections
//        }
//
//        for sec in sections {
//            arSections.append(parseFromCoreData(sec as! CDCourseChapterSection))
//        }
//        return arSections
//    }
//
//}
