//
//  ChannelsMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 15/05/18.
//

import Foundation

struct ChannelsMP {
    
    static func parseChannelsFrom(_ channelsJson: Data) -> ChannelData? {
        
        if let decoded = try? JSONDecoder().decode(Channels.self, from: channelsJson) {
            return decoded.channel
        } else {
            return nil
        }
    }
    
    static func parseAllChannelsFrom(_ channelsJson: Data) -> [AllChannels] {
        
        if let decoded = try? JSONDecoder().decode(AllChannelsKey.self, from: channelsJson) {
            return decoded.channels
        } else {
            return []
        }
    }
    
}
