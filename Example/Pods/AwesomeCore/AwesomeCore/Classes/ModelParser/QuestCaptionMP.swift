//
//  QuestCaptionMP.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 6/6/18.
//

import Foundation

struct QuestCaptionMP {
    
    static func parseQuestCaptionsFrom(_ questCaptionsJson: Data) -> QuestCaptions {
        if let decoded = try? JSONDecoder().decode(QuestCaptions.self, from: questCaptionsJson) {
            return decoded
        } else {
            return QuestCaptions(captions: [])
        }
    }
    
}
