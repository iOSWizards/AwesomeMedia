//
//  QuestSectionInfoMP.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/3/17.
//

import Foundation

struct QuestSectionInfoMP {
    
    static func parseQuestSectionInfoFrom(_ questSectionInfoJSON: Data) -> QuestSectionInfo? {
        
        var info: QuestSectionInfo?
        if let decoded = try? JSONDecoder().decode(QuestSectionInfoKey.self, from: questSectionInfoJSON) {
            info = decoded.info
        }
        
        return info
    }
    
}
