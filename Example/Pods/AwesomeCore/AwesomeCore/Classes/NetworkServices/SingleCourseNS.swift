//
//  SingleCourseNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 11/09/17.
//

import Foundation

class SingleCourseNS {
    
    static var shared = SingleCourseNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    var singleCourseRequest: URLSessionDataTask?
    
    init() {}
    
    func fetchSingleCourses(forcingUpdate: Bool = false, response: @escaping ([TrainingCard], ErrorData?) -> Void) {
        
        singleCourseRequest?.cancel()
        singleCourseRequest = nil
        
        singleCourseRequest = awesomeRequester.performRequestAuthorized(ACConstants.shared.librarySingleCoursesURL, forceUpdate: forcingUpdate) { (data, error, responseType) in
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.singleCourseRequest = nil
                response(SingleCourseMP.parseSingleCoursesFrom(jsonObject), nil)
            } else {
                self.singleCourseRequest = nil
                if let error = error {
                    response([], error)
                    return
                }
                response([], ErrorData(.unknown, "response Data could not be parsed"))
            }
        }
        
    }
    
}
