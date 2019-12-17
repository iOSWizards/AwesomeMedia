//
//  CategoryNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/09/17.
//

import Foundation

class CategoriesNS: BaseNS {
    
    static var shared = CategoriesNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    var categoryRequest: URLSessionDataTask?
    
    override init() {}
    
    func fetchCategories(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([ACCategory], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([ACCategory], ErrorData?) -> Void ) -> Bool {
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.categoryRequest = nil
                response(CategoryMP.parseCategoriesFrom(jsonObject: jsonObject), nil)
                return true
            } else {
                self.categoryRequest = nil
                if let error = error {
                    response([], error)
                    return false
                }
                response([], ErrorData(.unknown, "response Data could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.shared.categoriesURL
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        categoryRequest = awesomeRequester.performRequestAuthorized(url, forceUpdate: true) { (data, error, responseType) in
            if processResponse(data: data, error: error, response: response) {
                self.saveToCache(url, method: method, bodyDict: nil, data: data)
            }
        }
        
    }
    
}
