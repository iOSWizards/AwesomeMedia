//
//  QuestChannelMP.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 7/23/18.
//

import Foundation

struct QuestMediaMP {
    
    static func parseMediaFrom(_ json: Data) -> QuestMedia? {
        var media: QuestMedia?
        do {
            let decoded = try JSONDecoder().decode(SingleQuestMediaDataKey.self, from: json)
            media = decoded.data.media
        } catch {
            print("\(#function) error: \(error)")
        }
        return media
    }
    
}
