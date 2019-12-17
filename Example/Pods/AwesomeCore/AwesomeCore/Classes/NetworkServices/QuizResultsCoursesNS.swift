//
//  QuizResultsCoursesNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/03/18.
//

import Foundation

class QuizResultsCoursesNS: BaseNS {
    
    static let shared = QuizResultsCoursesNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    var lastQuizResultsCoursesRequest: URLSessionDataTask?
    
    func fetchQuizResultsCourses(withIds ids: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([QuizCourses], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([QuizCourses], ErrorData?) -> Void ) -> Bool {
            if let jsonObject = data {
                self.lastQuizResultsCoursesRequest = nil
                response(QuizResultsCoursesMP.parseQuizCoursesFrom(jsonObject).courses, nil)
                return true
            } else {
                self.lastQuizResultsCoursesRequest = nil
                if let error = error {
                    response([], error)
                    return false
                }
                response([], ErrorData(.unknown, "response Data could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.shared.quizResultsCourses
        let method: URLMethod = .POST
        let jsonBody = ["sub_category_ids": ids as AnyObject]
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: jsonBody), response: response)
        }
        
        lastQuizResultsCoursesRequest = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: jsonBody, data: data)
                }
        })
    }
}
