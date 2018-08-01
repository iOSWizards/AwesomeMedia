//
//  QuestPageNS.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 3/5/18.
//

import Foundation

class QuestPageNS {
    
    static let shared = QuestPageNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var lastQuestPageRequest: URLSessionDataTask?
    
    func fetchPage(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestPage?, ErrorData?) -> Void) {
        
        var didRespondCachedData = false
        
        func processResponse(data: Data?, response: @escaping (QuestPage?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            let page = QuestPageMP.parseQuestPageFrom(data)
            response(page, nil)
            
            return page != nil
        }
        
        func fetchFromAPI(forceUpdate: Bool) {
            
            // cancel previews request only if should
            if params.contains(.canCancelRequest) {
                lastQuestPageRequest?.cancel()
                lastQuestPageRequest = nil
            }
            
            lastQuestPageRequest = requester.performRequestAuthorized(
                ACConstants.shared.questsURL, forceUpdate: forceUpdate, method: .POST, jsonBody: QuestGraphQLModel.querySingleQuestPage(withId: id), completion: { (data, error, responseType) in
                    self.lastQuestPageRequest = nil
                    
                    //process response
                    let hasResponse = processResponse(data: data, response: response)
                    
                    //fetches again based on response type
                    if !forceUpdate && responseType == .cached {
                        didRespondCachedData = hasResponse
                        
                        fetchFromAPI(forceUpdate: true)
                    } else if let error = error {
                        print("Error fetching from API: \(error.message)")
                        
                        if !didRespondCachedData {
                            response(nil, error)
                        }
                    }
            })
        }
        
        // fetches from cache if the case
        if params.contains(.shouldFetchFromCache) {
            fetchFromAPI(forceUpdate: false)
        } else {
            fetchFromAPI(forceUpdate: true)
        }
    }
}

