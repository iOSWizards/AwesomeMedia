//
//  QuestNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/09/17.
//

import Foundation

class QuestNS: BaseNS {
    
    static let shared = QuestNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    let url = ACConstants.shared.questsURL
    let method: URLMethod = .POST
    
    func fetchQuests(params: AwesomeCoreNetworkServiceParams = .standard, withQuery query: [String: AnyObject] = QuestGraphQLModel.queryQuests(), response: @escaping ([Quest], ErrorData?, AwesomeResponseType) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, responseType: AwesomeResponseType, response: @escaping ([Quest], ErrorData?, AwesomeResponseType) -> Void ) -> Bool {
            guard let data = data else {
                response([], nil, responseType)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response([], error, responseType)
                return false
            }
            
            let quests = QuestMP.parseQuestsFrom(data)
            response(quests, nil, responseType)
            return quests.count > 0
        }
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: query), responseType: .cached, response: response)
        }
        
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: query, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, responseType: .fromServer, response: response) {
                    self.saveToCache(self.url, method: self.method, bodyDict: query, data: data)
                }
        })
    }
    
    func fetchQuests(by progress: QuestProgress, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?, AwesomeResponseType) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, responseType: AwesomeResponseType, response: @escaping ([Quest], ErrorData?, AwesomeResponseType) -> Void ) -> Bool {
            
            guard let data = data else {
                response([], nil, responseType)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response([], error, responseType)
                return false
            }
            
            let quests = QuestMP.parseQuestsFrom(data)
            response(quests, nil, responseType)
            return quests.count > 0
        }
        
        let jsonBody = QuestGraphQLModel.queryQuests(withProgress: progress)
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: jsonBody), responseType: .cached, response: response)
        }
        
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, responseType: .fromServer, response: response) {
                    self.saveToCache(self.url, method: self.method, bodyDict: jsonBody, data: data)
                }
        })
    }
    
    func fetchCommunities(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([Quest], ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response([], nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response([], error)
                return false
            }
            
            let quests = QuestMP.parseQuestsFrom(data)
            response(quests, nil)
            return quests.count > 0
        }
        
        let jsonBody = QuestGraphQLModel.queryQuestCommunities()
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: jsonBody), response: response)
        }
        
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(self.url, method: self.method, bodyDict: jsonBody, data: data)
                }
        })
    }
    
    func fetchQuest(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (Quest?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (Quest?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response(nil, nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            let quest = QuestMP.parseQuestFrom(data)
            response(quest, nil)
            return quest != nil
        }
        
        let jsonBody = QuestGraphQLModel.querySingleQuest(withId: id)
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: jsonBody), response: response)
        }
        
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(self.url, method: self.method, bodyDict: jsonBody, data: data)
                }
        })
    }
    
    func fetchQuestIntakes(withId id: String, releaseStatus: String = "", releaseLimit: String = "", params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestIntake?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (QuestIntake?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response(nil, nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            let quest = QuestIntakeMP.parseQuestIntakeFrom(data)
            response(quest, nil)
            return quest != nil
        }
        
        let jsonBody = QuestGraphQLModel.querySingleQuestIntake(withId: id, releaseStatus: releaseStatus, releaseLimit: releaseLimit)
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: jsonBody), response: response)
        }
        
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, jsonBody: jsonBody, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(self.url, method: self.method, bodyDict: jsonBody, data: data)
                }
        })
    }
    
    func markContentComplete(withId id: String, response: @escaping (ErrorData?) -> Void) {
        
        _ = requester.performRequestAuthorized(
            url, shouldCache: false, method: method, jsonBody: QuestGraphQLModel.mutateMarkContentComplete(withId: id), completion: { (data, error, responseType) in
                self.process(data: data, error: error, response: response)
        })
    }
    
    func markTaskComplete(withId id: String, response: @escaping (ErrorData?) -> Void) {
        
        _ = requester.performRequestAuthorized(
            url, shouldCache: false, method: method, jsonBody: QuestGraphQLModel.mutateMarkTaskComplete(withId: id), completion: { (data, error, responseType) in
                self.process(data: data, error: error, response: response)
        })
    }
    
    func updateTaskComplete(withId id: String, details: String, response: @escaping (ErrorData?) -> Void) {
        
        _ = requester.performRequestAuthorized(
            url, shouldCache: false, method: method, jsonBody: QuestGraphQLModel.mutateUpdateTaskComplete(withId: id, details: details), completion: { (data, error, responseType) in
                self.process(data: data, error: error, response: response)
        })
    }
    
    func enrollUser(withId id: String, response: @escaping (ErrorData?) -> Void) {
        
        _ = requester.performRequestAuthorized(
            url, shouldCache: false, method: method, jsonBody: QuestGraphQLModel.mutateEnrollUser(withId: id), completion: { (data, error, responseType) in
                self.process(data: data, error: error, response: response)
        })
    }
    
    func enrollUserRelease(withId id: String, releaseId: String, response: @escaping (ErrorData?) -> Void) {
        
        _ = requester.performRequestAuthorized(
            url, shouldCache: false, method: method, jsonBody: QuestGraphQLModel.mutateEnrollUserRelease(withId: id, releaseId: releaseId), completion: { (data, error, responseType) in
                self.process(data: data, error: error, response: response)
        })
    }
    
}
