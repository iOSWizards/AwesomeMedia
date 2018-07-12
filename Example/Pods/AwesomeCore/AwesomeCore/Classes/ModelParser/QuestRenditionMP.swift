//
//  QuestRenditionMP.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/3/17.
//

import Foundation

struct QuestRenditionMP {
    
    static func parseQuestRenditionsFrom(_ questRenditionsJSON: Data) -> [QuestRendition] {
        
        var renditions: [QuestRendition] = []
        if let decoded = try? JSONDecoder().decode(QuestRenditions.self, from: questRenditionsJSON) {
            renditions = decoded.renditions
        }
        
        return renditions
    }
    
}
