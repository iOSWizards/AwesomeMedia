//
//  QuizResultsCoursesNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/03/18.
//

import Foundation

class QuizResultsCoursesNS {
    
    static let shared = QuizResultsCoursesNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var lastQuizResultsCoursesRequest: URLSessionDataTask?
    
    func fetchQuizResultsCourses(withIds ids: String, forcingUpdate: Bool = false, response: @escaping ([QuizCourses], ErrorData?) -> Void) {
        
        lastQuizResultsCoursesRequest?.cancel()
        lastQuizResultsCoursesRequest = nil
        
        lastQuizResultsCoursesRequest = awesomeRequester.performRequestAuthorized(
            ACConstants.shared.quizResultsCourses, forceUpdate: forcingUpdate, method: .POST, jsonBody: ["sub_category_ids": ids as AnyObject], completion: { (data, error, responseType) in
                
                if let jsonObject = data {
                    self.lastQuizResultsCoursesRequest = nil
                    response(QuizResultsCoursesMP.parseQuizCoursesFrom(jsonObject).courses, nil)
                } else {
                    self.lastQuizResultsCoursesRequest = nil
                    if let error = error {
                        response([], error)
                        return
                    }
                    response([], ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
}
