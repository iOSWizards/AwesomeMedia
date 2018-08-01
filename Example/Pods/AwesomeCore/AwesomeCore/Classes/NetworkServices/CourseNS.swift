//
//  CourseNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 30/06/17.
//

import Foundation

class CourseNS {
    
    static let shared = CourseNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var requests = [String: URLSessionDataTask]()
    var paginationData: PaginationData?
    var currentPage: Int = 1
    
    /// Fetches a Course based on its Academy Id.
    ///
    /// - Parameters:
    ///   - usingAcademy: Academy ID that onws a course.
    ///   - andCourse: Course id to be fetched.
    ///   - forcingUpdate: a flag used to force updating the local cache ( false by default )
    ///   - response: tupple with Course and message.
    func fetchCourse(usingAcademy: Int, andCourse: Int, forcingUpdate: Bool = false, response: @escaping (ACCourse?, ErrorData?) -> Void) {
        
        if andCourse <= 0 || usingAcademy <= 0 {
            response(nil, ErrorData(.generic, "Course \(andCourse) or Academy \(usingAcademy) are invalide"))
            return
        }
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.academyCourseURL, with: usingAcademy, andCourse)
        
        requests[url]?.cancel()
        requests[url] = nil
        
        requests[url] = awesomeRequester.performRequestAuthorized(url, forceUpdate: forcingUpdate) { (data, error, responseType) in
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.requests[url] = nil
                response(CourseMP.parseCourseFrom(jsonObject: jsonObject), nil)
            } else {
                self.requests[url] = nil
                if let error = error {
                    response(nil, error)
                    return
                }
                response(nil, ErrorData(.unknown, "response Data could not be parsed"))
            }
        }
    }
    
    /// Fetches Academy Courses based on the Academy id.
    ///
    /// - Parameters:
    ///   - usingAcademy: academyId to load courses of.
    ///   - forcingUpdate: a flag used to force updating the local cache ( false by default )
    ///   - response: in case of error an empty array of Courses and the proper error or
    ///     an array of courses an nill as error.
    func fetchCourses(usingAcademy: Int = 0, isFirstPage: Bool = true, forcingUpdate: Bool = false, itemsPerPage: Int = 20, response: @escaping ([ACCourse], PaginationData?, ErrorData?) -> Void) {
        
        if isFirstPage {
            //paginationData = nil
            currentPage = 1
        }
        
        if let pagination = paginationData, Double(currentPage) > ceil(Double(pagination.total)/Double(pagination.limit)) {
            response([ACCourse](), nil, nil)
            return
        }
        
        var url = ACConstants.buildURLWith(
            format: ACConstants.shared.coursesURL,
            with: String(itemsPerPage),
            String(currentPage))
        
        if usingAcademy > 0 {
            url = ACConstants.buildURLWith(
                format: ACConstants.shared.academyCoursesURL,
                with: String(usingAcademy),
                String(itemsPerPage),
                String(currentPage))
        }
        
        requests[url]?.cancel()
        requests[url] = nil
        
        requests[url] = awesomeRequester.performRequestAuthorized(url, forceUpdate: forcingUpdate) { (data, error, responseType) in
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.currentPage += 1
                self.requests[url] = nil
                let paginationData = PaginationDataMP.parsePaginationFrom(jsonObject, key: "meta")
                self.paginationData = paginationData
                response(CourseMP.parseCoursesFrom(jsonObject: jsonObject), paginationData, nil)
            } else {
                self.requests[url] = nil
                if let error = error {
                    response([ACCourse](), nil, error)
                    return
                }
                response([ACCourse](), nil, ErrorData(.unknown, "response Data could not be parsed"))
            }
        }
    }
    
}

