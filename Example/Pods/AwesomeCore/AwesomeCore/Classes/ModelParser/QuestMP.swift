//
//  QuestMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 13/09/17.
//

import Foundation

struct QuestMP {
    
    static func parseQuestsFrom(_ QuestsJSON: Data) -> [Quest] {
        
        var quests: [Quest] = []
        if let decoded = try? JSONDecoder().decode(QuestsDataKey.self, from: QuestsJSON) {
            quests = decoded.data.quests
        }
        
        return quests
    }
    
    static func parseQuestFrom(_ QuestsJSON: Data) -> Quest? {
        var quest: Quest?
        do {
            let decoded = try JSONDecoder().decode(SingleQuestDataKey.self, from: QuestsJSON)
            quest = decoded.data.quest
        } catch {
            print("\(#function) error: \(error)")
        }
        return quest
    }
    
}
