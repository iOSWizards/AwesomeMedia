//
//  CourseNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 30/06/17.
//

import Foundation

class CourseNS: BaseNS {
    
    static let shared = CourseNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
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
    func fetchCourse(usingAcademy: Int, andCourse: Int, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (ACCourse?, ErrorData?) -> Void) {
        
        if andCourse <= 0 || usingAcademy <= 0 {
            response(nil, ErrorData(.generic, "Course \(andCourse) or Academy \(usingAcademy) are invalide"))
            return
        }
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (ACCourse?, ErrorData?) -> Void ) -> Bool {
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                response(CourseMP.parseCourseFrom(jsonObject: jsonObject), nil)
                return true
            } else {
                if let error = error {
                    response(nil, error)
                    return false
                }
                response(nil, ErrorData(.unknown, "response Data could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.academyCourseURL, with: usingAcademy, andCourse)
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        requests[url] = awesomeRequester.performRequestAuthorized(url, forceUpdate: true) { (data, error, responseType) in
            if processResponse(data: data, error: error, response: response) {
                self.saveToCache(url, method: method, bodyDict: nil, data: data)
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
    func fetchCourses(usingAcademy: Int = 0, categoryId: Int? = nil, isFirstPage: Bool = true, params: AwesomeCoreNetworkServiceParams = .standard, itemsPerPage: Int = 20, shouldIncrementPage: Bool = true, response: @escaping ([ACCourse], PaginationData?, ErrorData?, AwesomeResponseType) -> Void) {
        
        if isFirstPage {
            paginationData = nil
            currentPage = 1
        }
        
        if let pagination = paginationData, Double(currentPage) > ceil(Double(pagination.total)/Double(pagination.limit)) {
            response([ACCourse](), nil, nil, .fromServer)
            return
        }
        
        func processResponse(data: Data?, error: ErrorData? = nil, responseType: AwesomeResponseType, response: @escaping ([ACCourse], PaginationData?, ErrorData?, AwesomeResponseType) -> Void ) -> Bool {
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                let paginationData = PaginationDataMP.parsePaginationFrom(jsonObject, key: "meta")
                self.paginationData = paginationData
                response(CourseMP.parseCoursesFrom(jsonObject: jsonObject), paginationData, nil, responseType)
                return true
            } else {
                if let error = error {
                    response([ACCourse](), nil, error, responseType)
                    return false
                }
                response([ACCourse](), nil, ErrorData(.unknown, "response Data could not be parsed"), responseType)
                return false
            }
        }
        
        var url = ACConstants.buildURLWith(
            format: ACConstants.shared.coursesURL,
            with: String(itemsPerPage),
            String(currentPage))
        let method: URLMethod = .GET
        
        if usingAcademy > 0 {
            url = ACConstants.buildURLWith(
                format: ACConstants.shared.academyCoursesURL,
                with: String(usingAcademy),
                String(itemsPerPage),
                String(currentPage))
        }
        
        if let categoryId = categoryId {
            url = url + "&category_id=\(categoryId)"
        }
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), responseType: .cached, response: response)
        }
        
        requests[url] = awesomeRequester.performRequestAuthorized(url, forceUpdate: true) { (data, error, responseType) in
            if processResponse(data: data, error: error, responseType: .fromServer, response: response) {
                self.saveToCache(url, method: method, bodyDict: nil, data: data)
            }
        }
        if shouldIncrementPage {
            self.currentPage += 1
        }
    }
    
}
