//
//  ChannelsBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 16/05/18.
//

import Foundation

public struct ChannelsBO {
    
    static var channelsNS = ChannelsNS.shared
    public static var shared = ChannelsBO()
    
    private init() {}
    
    public static func fetchChannel(with academyId: Int, forcingUpdate: Bool = false, response: @escaping (ChannelData?, ErrorData?) -> Void) {
        channelsNS.fetchChannelData(with: academyId, response: { (channel, error) in
            DispatchQueue.main.async {
                response(channel, error)
            }
        })
    }
    
    public static func fetchAllChannels(forcingUpdate: Bool = false, response: @escaping ([AllChannels], ErrorData?) -> Void) {
        channelsNS.fetchAllChannels(response: { (channel, error) in
            DispatchQueue.main.async {
                response(channel, error)
            }
        })
    }
}
