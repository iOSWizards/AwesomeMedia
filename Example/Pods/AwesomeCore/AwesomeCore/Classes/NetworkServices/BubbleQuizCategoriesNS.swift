//
//  BubbleQuizCategoriesNS.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 25/02/19.
//

import Foundation

class BubbleQuizCategoriesNS: BaseNS {
    
    static let shared = BubbleQuizCategoriesNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    func getCategories(params: AwesomeCoreNetworkServiceParams, _ response:@escaping ([BubbleQuizCategory], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([BubbleQuizCategory], ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response([], nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response([], error)
                return false
            }
            
            let categories = BubbleQuizCategoriesMP.parse(data)
            response(categories, nil)
            return categories.count > 0
        }
        
        let jsonBody: [String: AnyObject] = BubbleQuizGraphQLModel.quizCategoriesModel()
        let method: URLMethod = .POST
        let url: String = ACConstants.shared.questsURL
        
//        if params.contains(.shouldFetchFromCache) {
//            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: jsonBody), response: response)
//        }
        
        _ = requester.performRequest(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: jsonBody, data: data)
                }
        })
    }
    
}


