//
//  QuizCategoriesNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 22/02/18.
//

import Foundation

class QuizCategoriesNS {
    
    static let shared = QuizCategoriesNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var lastQuizCategoriesRequest: URLSessionDataTask?
    
    func fetchQuizCategories(forcingUpdate: Bool = false, response: @escaping ([QuizCategory], ErrorData?) -> Void) {
        
        lastQuizCategoriesRequest?.cancel()
        lastQuizCategoriesRequest = nil
        
        lastQuizCategoriesRequest = awesomeRequester.performRequestAuthorized(
            ACConstants.shared.quizCategories, forceUpdate: forcingUpdate, completion: { (data, error, responseType) in
                
                if let jsonObject = data {
                    self.lastQuizCategoriesRequest = nil
                    response(QuizCategoriesMP.parseCategoriesFrom(jsonObject).categories, nil)
                } else {
                    self.lastQuizCategoriesRequest = nil
                    if let error = error {
                        response([], error)
                        return
                    }
                    response([], ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
}
