//
//  CategoryTrainingsNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/09/17.
//

import Foundation

class CategoryTrainingsNS {
    
    static var shared = CategoryTrainingsNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    var categoryTrainingsRequest: URLSessionDataTask?
    
    init() {}
    
    func fetchCategoryTrainings(withCategory category: String, forcingUpdate: Bool = false, response: @escaping (CategoryTrainings?, ErrorData?) -> Void) {
        
        categoryTrainingsRequest?.cancel()
        categoryTrainingsRequest = nil
        
        categoryTrainingsRequest = awesomeRequester.performRequestAuthorized(String(format: ACConstants.shared.categoryTrainingsURL, category), forceUpdate: forcingUpdate) { (data, error, responseType) in
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.categoryTrainingsRequest = nil
                response(CategoryTrainingsMP.parseCategoryTrainingsFrom(jsonObject), nil)
            } else {
                self.categoryTrainingsRequest = nil
                if let error = error {
                    response(nil, error)
                    return
                }
                response(nil, ErrorData(.unknown, "response Data could not be parsed"))
            }
        }
        
    }
    
}

