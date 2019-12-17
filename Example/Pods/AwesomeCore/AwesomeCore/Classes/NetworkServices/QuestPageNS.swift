//
//  QuestPageNS.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 3/5/18.
//

import Foundation

class QuestPageNS: BaseNS {
    
    static let shared = QuestPageNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    var lastQuestPageRequest: URLSessionDataTask?
    
    func fetchPage(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestPage?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (QuestPage?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response(nil, nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            let page = QuestPageMP.parseQuestPageFrom(data)
            response(page, nil)
            return page != nil
        }
        
        let jsonBody = QuestGraphQLModel.querySingleQuestPage(withId: id)
        let method: URLMethod = .POST
        let url = ACConstants.shared.questsURL
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: jsonBody), response: response)
        }
        
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: jsonBody, data: data)
                }
        })
    }
}

