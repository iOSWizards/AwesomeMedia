//
//  QuestBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/09/17.
//

import Foundation

public struct QuestBO {
    
    static var questNS = QuestNS.shared
    //static var questDA = QuestDA()
    
    private init() {}
    
    public static func fetchQuests(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?, AwesomeResponseType) -> Void) {
        
        func sendResponse(_ quests: [Quest], _ error: ErrorData?, _ responseType: AwesomeResponseType) {
            DispatchQueue.main.async { response(quests, error, responseType) }
        }
        
        func fetchFromAPI() {
            questNS.fetchQuests(params: params) { (quests, error, responseType) in
                sendResponse(quests, error, responseType)
            }
        }
        
        fetchFromAPI()
    }
    
    public static func fetchQuests(by progress: QuestProgress, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?, AwesomeResponseType) -> Void) {
        
        func sendResponse(_ quests: [Quest], _ error: ErrorData?, _ responseType: AwesomeResponseType) {
            DispatchQueue.main.async { response(quests, error, responseType) }
        }
        
        func fetchFromAPI() {
            questNS.fetchQuests(by: progress, params: params) { (quests, error, responseType) in
                sendResponse(quests, error, responseType)
            }
        }
        
        fetchFromAPI()
    }
    
    public static func fetchMyTime(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?, AwesomeResponseType) -> Void) {
        
        func sendResponse(_ quests: [Quest], _ error: ErrorData?, _ responseType: AwesomeResponseType) {
            DispatchQueue.main.async { response(quests, error, responseType) }
        }
        
        func fetchFromAPI() {
            questNS.fetchQuests(params: params, withQuery: QuestGraphQLModel.queryMyTime()) { (quests, error, responseType) in
                sendResponse(quests, error, responseType)
            }
        }
        
        fetchFromAPI()
    }
    
    public static func fetchSpotlightQuests(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?, AwesomeResponseType) -> Void) {
        
        func sendResponse(_ quests: [Quest], _ error: ErrorData?, _ responseType: AwesomeResponseType) {
            DispatchQueue.main.async { response(quests, error, responseType) }
        }
        
        func fetchFromAPI() {
            questNS.fetchQuests(params: params, withQuery: QuestGraphQLModel.querySpotlightQuests()) { (quests, error, responseType) in
                sendResponse(quests, error, responseType)
            }
        }
        
        fetchFromAPI()
    }
    
    public static func fetchCommunities(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?) -> Void) {
        
        func sendResponse(_ quests: [Quest], _ error: ErrorData?) {
            DispatchQueue.main.async { response(quests, error) }
        }
        
        func fetchFromAPI() {
            questNS.fetchCommunities(params: params) { (quests, error) in
                sendResponse(quests, error)
            }
        }
        
        fetchFromAPI()
    }
    
    public static func fetchQuest(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (Quest?, ErrorData?) -> Void) {
        func sendResponse(_ quest: Quest?, _ error: ErrorData?) {
            DispatchQueue.main.async { response(quest, error) }
        }
        
        func fetchFromAPI() {
            questNS.fetchQuest(withId: id, params: params) { (quest, error) in
                DispatchQueue.main.async {
                    response(quest, error)
                }
            }
        }
        
        fetchFromAPI()
    }
    
    public static func fetchQuestIntakes(withId id: String, releaseStatus:
        String, releaseLimit: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestIntake?, ErrorData?) -> Void) {
        func sendResponse(_ quest: QuestIntake?, _ error: ErrorData?) {
            DispatchQueue.main.async { response(quest, error) }
        }
        
        func fetchFromAPI() {
            questNS.fetchQuestIntakes(withId: id, releaseStatus: releaseStatus, releaseLimit: releaseLimit,  params: params) { (quest, error) in
                DispatchQueue.main.async {
                    response(quest, error)
                }
            }
        }
        
        fetchFromAPI()
    }
    
    public static func markContentComplete(withId id: String, response: @escaping (ErrorData?) -> Void) {
        questNS.markContentComplete(withId: id) { (error) in
            DispatchQueue.main.async {
                response(error)
            }
        }
    }
    
    public static func markTaskComplete(withId id: String, response: @escaping (ErrorData?) -> Void) {
        questNS.markTaskComplete(withId: id) { (error) in
            DispatchQueue.main.async {
                response(error)
            }
        }
    }
    
    public static func updateTaskComplete(withId id: String, details: String, response: @escaping (ErrorData?) -> Void) {
        questNS.updateTaskComplete(withId: id, details: details) { (error) in
            DispatchQueue.main.async {
                response(error)
            }
        }
    }
    
    public static func enrollUser(withId id: String, response: @escaping (ErrorData?) -> Void) {
        questNS.enrollUser(withId: id) { (error) in
            DispatchQueue.main.async {
                response(error)
            }
        }
    }
    
}
