//
//  QuestUserProgressMP.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/3/17.
//

import Foundation

struct QuestUserProgressMP {
    
    static func parseQuestUserProgressFrom(_ questUserProgressJSON: Data) -> QuestUserProgress? {
        
        var userProgress: QuestUserProgress?
        if let decoded = try? JSONDecoder().decode(QuestUserProgressKey.self, from: questUserProgressJSON) {
            userProgress = decoded.userProgress
        }
        
        return userProgress
    }
    
}
