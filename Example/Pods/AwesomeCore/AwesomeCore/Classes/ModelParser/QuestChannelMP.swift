//
//  QuestChannelMP.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 7/23/18.
//

import Foundation

struct QuestChannelMP {
    
    static func parseChannelsFrom(_ json: Data) -> [QuestChannel] {
        
        var channels: [QuestChannel] = []
        if let decoded = try? JSONDecoder().decode(QuestChannelsDataKey.self, from: json) {
            channels = decoded.data.channels
        }
        
        return channels
    }
    
    static func parseChannelFrom(_ json: Data) -> QuestChannel? {
        var channel: QuestChannel?
        do {
            let decoded = try JSONDecoder().decode(SingleQuestChannelDataKey.self, from: json)
            channel = decoded.data.channel
        } catch {
            print("\(#function) error: \(error)")
        }
        return channel
    }
    
}
