//
//  QuestSectionMP.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/3/17.
//

import Foundation

struct QuestSectionMP {
    
    static func parseQuestSectionsFrom(_ questSectionsJSON: Data) -> [QuestSection] {
        
        var sections: [QuestSection] = []
        if let decoded = try? JSONDecoder().decode(QuestSections.self, from: questSectionsJSON) {
            sections = decoded.sections
        }
        
        return sections
    }
    
}
