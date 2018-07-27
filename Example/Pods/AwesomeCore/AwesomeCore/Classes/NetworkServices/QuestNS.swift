//
//  QuestNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/09/17.
//

import Foundation

class QuestNS {
    
    static let shared = QuestNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var lastQuestRequest: URLSessionDataTask?
    var lastQuestPageRequest: URLSessionDataTask?
    var lastContentCompleteRequest: URLSessionDataTask?
    var lastTaskCompleteRequest: URLSessionDataTask?
    var lastUpdateTaskCompleteRequest: URLSessionDataTask?
    var lastEnrollUserRequest: URLSessionDataTask?
    
    func fetchQuests(params: AwesomeCoreNetworkServiceParams = .standard, withQuery query: [String: AnyObject] = QuestGraphQLModel.queryQuests(), response: @escaping ([Quest], ErrorData?) -> Void) {
        
        var didRespondCachedData = false
        
        func processResponse(data: Data?, response: @escaping ([Quest], ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            let quests = QuestMP.parseQuestsFrom(data)
            response(quests, nil)
            
            return quests.count > 0
        }
        
        func fetchFromAPI(forceUpdate: Bool) {
            
            _ = requester.performRequestAuthorized(
                ACConstants.shared.questsURL, forceUpdate: forceUpdate, method: .POST, jsonBody: query, completion: { (data, error, responseType) in
                    
                    //process response
                    let hasResponse = processResponse(data: data, response: response)
                    
                    //fetches again based on response type
                    if !forceUpdate && responseType == .cached {
                        didRespondCachedData = hasResponse
                        
                        fetchFromAPI(forceUpdate: true)
                    } else if let error = error {
                        print("Error fetching from API: \(error.message)")
                        
                        if !didRespondCachedData {
                            response([], error)
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
    
    func fetchCommunities(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?) -> Void) {
        
        var didRespondCachedData = false
        
        func processResponse(data: Data?, response: @escaping ([Quest], ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            let quests = QuestMP.parseQuestsFrom(data)
            response(quests, nil)
            
            return quests.count > 0
        }
        
        func fetchFromAPI(forceUpdate: Bool) {
            
            _ = requester.performRequestAuthorized(
                ACConstants.shared.questsURL, forceUpdate: forceUpdate, method: .POST, jsonBody: QuestGraphQLModel.queryQuestCommunities(), completion: { (data, error, responseType) in
                    
                    //process response
                    let hasResponse = processResponse(data: data, response: response)
                    
                    //fetches again based on response type
                    if !forceUpdate && responseType == .cached {
                        didRespondCachedData = hasResponse
                        
                        fetchFromAPI(forceUpdate: true)
                    } else if let error = error {
                        print("Error fetching from API: \(error.message)")
                        
                        if !didRespondCachedData {
                            response([], error)
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
    
    func fetchQuest(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (Quest?, ErrorData?) -> Void) {
        
        var didRespondCachedData = false
        
        func processResponse(data: Data?, response: @escaping (Quest?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            let quest = QuestMP.parseQuestFrom(data)
            response(quest, nil)
            
            return quest != nil
        }
        
        func fetchFromAPI(forceUpdate: Bool) {
            
            // cancel previews request only if should
            if params.contains(.canCancelRequest) {
                lastQuestRequest?.cancel()
                lastQuestRequest = nil
            }
            
            lastQuestRequest = requester.performRequestAuthorized(
                ACConstants.shared.questsURL, forceUpdate: forceUpdate, method: .POST, jsonBody: QuestGraphQLModel.querySingleQuest(withId: id), completion: { (data, error, responseType) in
                    self.lastQuestRequest = nil
                    
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
    
    func markContentComplete(withId id: String, response: @escaping (ErrorData?) -> Void) {
        
        lastContentCompleteRequest?.cancel()
        lastContentCompleteRequest = nil
        
        lastContentCompleteRequest = requester.performRequestAuthorized(
            ACConstants.shared.questsURL, shouldCache: false, method: .POST, jsonBody: QuestGraphQLModel.mutateMarkContentComplete(withId: id), completion: { (data, error, responseType) in
                if let jsonObject = data {
                    let questError = QuestErrorMP.parseQuestErrorFrom(jsonObject)
                    if questError.count > 0 {
                        self.lastContentCompleteRequest = nil
                        response(ErrorData(.generic, "An error occurred during your request."))
                    } else {
                        self.lastContentCompleteRequest = nil
                        response(nil)
                    }
                } else {
                    self.lastContentCompleteRequest = nil
                    if let error = error {
                        response(error)
                        return
                    }
                    response(ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
    
    func markTaskComplete(withId id: String, response: @escaping (ErrorData?) -> Void) {
        
        lastTaskCompleteRequest?.cancel()
        lastTaskCompleteRequest = nil
        
        lastTaskCompleteRequest = requester.performRequestAuthorized(
            ACConstants.shared.questsURL, shouldCache: false, method: .POST, jsonBody: QuestGraphQLModel.mutateMarkTaskComplete(withId: id), completion: { (data, error, responseType) in
                if let jsonObject = data {
                    let questError = QuestErrorMP.parseQuestErrorFrom(jsonObject)
                    if questError.count > 0 {
                        self.lastTaskCompleteRequest = nil
                        response(ErrorData(.generic, "An error occurred during your request."))
                    } else {
                        self.lastTaskCompleteRequest = nil
                        response(nil)
                    }
                } else {
                    self.lastTaskCompleteRequest = nil
                    if let error = error {
                        response(error)
                        return
                    }
                    response(ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
    
    func updateTaskComplete(withId id: String, details: String, response: @escaping (ErrorData?) -> Void) {
        
        lastUpdateTaskCompleteRequest?.cancel()
        lastUpdateTaskCompleteRequest = nil
        
        lastUpdateTaskCompleteRequest = requester.performRequestAuthorized(
            ACConstants.shared.questsURL, shouldCache: false, method: .POST, jsonBody: QuestGraphQLModel.mutateUpdateTaskComplete(withId: id, details: details), completion: { (data, error, responseType) in
                if let jsonObject = data {
                    let questError = QuestErrorMP.parseQuestErrorFrom(jsonObject)
                    if questError.count > 0 {
                        self.lastUpdateTaskCompleteRequest = nil
                        response(ErrorData(.generic, "An error occurred during your request."))
                    } else {
                        self.lastUpdateTaskCompleteRequest = nil
                        response(nil)
                    }
                } else {
                    self.lastUpdateTaskCompleteRequest = nil
                    if let error = error {
                        response(error)
                        return
                    }
                    response(ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
    
    func enrollUser(withId id: String, response: @escaping (ErrorData?) -> Void) {
        
        lastEnrollUserRequest?.cancel()
        lastEnrollUserRequest = nil
        
        lastEnrollUserRequest = requester.performRequestAuthorized(
            ACConstants.shared.questsURL, shouldCache: false, method: .POST, jsonBody: QuestGraphQLModel.mutateEnrollUser(withId: id), completion: { (data, error, responseType) in
                if let jsonObject = data {
                    let questError = QuestErrorMP.parseQuestErrorFrom(jsonObject)
                    if questError.count > 0 {
                        self.lastEnrollUserRequest = nil
                        response(ErrorData(.generic, "An error occurred during your request."))
                    } else {
                        self.lastEnrollUserRequest = nil
                        response(nil)
                    }
                } else {
                    self.lastEnrollUserRequest = nil
                    if let error = error {
                        response(error)
                        return
                    }
                    response(ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
    
}

