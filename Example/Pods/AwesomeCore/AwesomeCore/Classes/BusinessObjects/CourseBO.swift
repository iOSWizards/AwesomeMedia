//
//  CourseBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 30/06/17.
//

import Foundation

public struct CourseBO {
    
    static var courseNS = CourseNS.shared
    //    static var courseDA = CourseDA.shared
    //    static var sectionDA = CourseChapterSectionDA()
    
    private init() {}
    
    /// Fetches a Course based on its Academy Id.
    ///
    /// **Note: This block operation is sent back to the Main thread once its execution is done.**
    ///
    /// - Parameters:
    ///   - usingAcademy: Academy ID that onws a course.
    ///   - andCourse: Course id to be fetched.
    ///   - forcingUpdate: a flag used to force updating the local cache ( false by default )
    ///   - completion: a ACCourse or nil in case it's not found.
    public static func fetchCourse(
        usingAcademy: Int,
        andCourse: Int,
        forcingUpdate: Bool = false,
        completion: @escaping (ACCourse?, ErrorData?) -> Void) {
        
        courseNS.fetchCourse(usingAcademy: usingAcademy, andCourse: andCourse) { (course, errorData) in
            if course != nil {
                AwesomeCoreStorage.lastCourseId = andCourse
            }
            DispatchQueue.main.async {
                completion(course, errorData)
            }
        }
    }
    
    public static func saveLocalSection(withSection section: Section) {
        guard let sectionContinueAtTime = section.continueAtTime else {
            return
        }
        UserDefaults.standard.set(sectionContinueAtTime, forKey: "\(section.courseId)-\(section.courseChapterId)-\(section.courseChapterSectionId)")
    }
    
    public static func loadSection(withSection section: Section, courseId: Int, chapterId: Int) -> Double {
        return UserDefaults.standard.double(forKey: "\(courseId)-\(chapterId)-\(section.courseChapterSectionId)")
    }
    
    /// Fetches Academy Courses based on the Academy id.
    ///
    /// **Note: This block operation is sent back to the Main thread once its execution is done.**
    ///
    /// - Parameters:
    ///   - usingAcademy: academyId to load courses of, in case omitted all
    ///courses will be returned to the given user authenticated.
    ///   - forcingUpdate: a flag used to force updating the local cache ( false by default )
    ///   - completion: in case of error an empty array of Courses and the proper error or
    ///     an array of courses an nill as error.
    public static func fetchCourses(
        usingAcademy: Int = 0,
        categoryId: Int? = nil,
        isFirstPage: Bool = true,
        itemsPerPage: Int = 20,
        shouldIncrementPage: Bool = true,
        params: AwesomeCoreNetworkServiceParams = .standard,
        completion: @escaping ([ACCourse], Int, ErrorData?, AwesomeResponseType) -> Void) {
        
        courseNS.fetchCourses(usingAcademy: usingAcademy, categoryId: categoryId, isFirstPage: isFirstPage, params: params, itemsPerPage: itemsPerPage, shouldIncrementPage: shouldIncrementPage) { (courses, paginationData, error, responseType) in
            DispatchQueue.main.async {
                completion(courses, paginationData?.total ?? 0, error, responseType)
            }
        }
    }

    public static func cancelAllCoursesRequests() {
        for request in CourseNS.shared.requests {
            request.value.cancel()
        }
    }
    
}
