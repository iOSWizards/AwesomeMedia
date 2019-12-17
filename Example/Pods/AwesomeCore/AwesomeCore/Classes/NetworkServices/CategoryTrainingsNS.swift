//
//  CategoryTrainingsNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/09/17.
//

import Foundation

class CategoryTrainingsNS: BaseNS {
    
    static var shared = CategoryTrainingsNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    var categoryTrainingsRequest: URLSessionDataTask?
    
    override init() {}
    
    func fetchCategoryTrainings(withCategory category: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (CategoryTrainings?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (CategoryTrainings?, ErrorData?) -> Void ) -> Bool {
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.categoryTrainingsRequest = nil
                response(CategoryTrainingsMP.parseCategoryTrainingsFrom(jsonObject), nil)
                return true
            } else {
                self.categoryTrainingsRequest = nil
                if let error = error {
                    response(nil, error)
                    return false
                }
                response(nil, ErrorData(.unknown, "response Data could not be parsed"))
                return false
            }
        }
        
        let url = String(format: ACConstants.shared.categoryTrainingsURL, category)
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        categoryTrainingsRequest = awesomeRequester.performRequestAuthorized(url, forceUpdate: true) { (data, error, responseType) in
            if processResponse(data: data, error: error, response: response) {
                self.saveToCache(url, method: method, bodyDict: nil, data: data)
            }
        }
        
    }
    
}

