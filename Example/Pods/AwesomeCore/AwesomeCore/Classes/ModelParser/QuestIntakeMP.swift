//
//  QuestIntakeMP.swift
//  Auth0-iOS10.0
//
//  Created by Maail on 12/04/2019.
//

import Foundation

struct QuestIntakeMP {
    
    static func parseQuestIntakeFrom(_ QuestsJSON: Data) -> QuestIntake? {
        var questIntake: QuestIntake?
        do {
            let decoded = try JSONDecoder().decode(QuestIntakeDataKey.self, from: QuestsJSON)
            questIntake = decoded.data.quest
        } catch {
            print("\(#function) error: \(error)")
        }
        return questIntake
    }
    
}
