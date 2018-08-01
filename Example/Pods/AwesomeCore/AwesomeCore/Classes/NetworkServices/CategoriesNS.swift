//
//  CategoryNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/09/17.
//

import Foundation

class CategoriesNS {
    
    static var shared = CategoriesNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    var categoryRequest: URLSessionDataTask?
    
    init() {}
    
    func fetchCategories(forcingUpdate: Bool = false, response: @escaping ([ACCategory], ErrorData?) -> Void) {
        
        categoryRequest?.cancel()
        categoryRequest = nil
        
        categoryRequest = awesomeRequester.performRequestAuthorized(ACConstants.shared.categoriesURL, forceUpdate: forcingUpdate) { (data, error, responseType) in
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.categoryRequest = nil
                response(CategoryMP.parseCategoriesFrom(jsonObject: jsonObject), nil)
            } else {
                self.categoryRequest = nil
                if let error = error {
                    response([], error)
                    return
                }
                response([], ErrorData(.unknown, "response Data could not be parsed"))
            }
        }
        
    }
    
}
