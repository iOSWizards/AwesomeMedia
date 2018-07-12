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
    
    public static func fetchQuests(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?) -> Void) {
        
        func sendResponse(_ quests: [Quest], _ error: ErrorData?) {
            DispatchQueue.main.async { response(quests, error) }
        }
        
        func fetchFromAPI() {
            questNS.fetchQuests(params: params) { (quests, error) in
                sendResponse(quests, error)
            }
        }
        
        fetchFromAPI()
    }
    
    public static func fetchMyTime(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?) -> Void) {
        
        func sendResponse(_ quests: [Quest], _ error: ErrorData?) {
            DispatchQueue.main.async { response(quests, error) }
        }
        
        func fetchFromAPI() {
            questNS.fetchQuests(params: params, withQuery: QuestGraphQLModel.queryMyTime()) { (quests, error) in
                sendResponse(quests, error)
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
