//
//  QuestSettingsMP.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/3/17.
//

import Foundation

struct QuestSettingsMP {
    
    static func parseQuestSettingsFrom(_ questSettingsJSON: Data) -> QuestSettings? {
        
        var settings: QuestSettings?
        if let decoded = try? JSONDecoder().decode(QuestSettingsKey.self, from: questSettingsJSON) {
            settings = decoded.settings
        }
        
        return settings
    }
    
}
