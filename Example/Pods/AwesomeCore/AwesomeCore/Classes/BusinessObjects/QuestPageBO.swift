//
//  QuestPageBO.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 3/5/18.
//

import Foundation

public struct QuestPageBO {
    
    static var questPageNS = QuestPageNS.shared
    //static var questPageDA = QuestPageDA()
    
    public static func fetchQuestPage(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestPage?, ErrorData?) -> Void) {
        
        func sendResponse(_ page: QuestPage?, _ error: ErrorData?) {
            DispatchQueue.main.async { response(page, error) }
        }
        
        func fetchFromAPI() {
            questPageNS.fetchPage(withId: id, params: params) { (page, error) in
                DispatchQueue.main.async {
                    response(page, error)
                }
            }
        }
        
        fetchFromAPI()
    }
}
