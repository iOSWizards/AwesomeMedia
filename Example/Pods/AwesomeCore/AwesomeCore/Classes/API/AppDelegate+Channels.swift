//
//  AppDelegate+Channels.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 7/23/18.
//

import Foundation
import RealmSwift

public extension AwesomeCore {
    
    // MARK: - Channels
    
    public static func fetchChannels(params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int = 0, latestMediaLimit: Int = 0, response: @escaping ([QuestChannel], ErrorData?) -> Void) {
        QuestChannelBO.fetchChannels(params: params, featuredMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit, response: response)
    }
    
    public static func fetchChannel(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int = 0, latestMediaLimit: Int = 0, response: @escaping (QuestChannel?, ErrorData?) -> Void) {
        QuestChannelBO.fetchChannel(withId: id, params: params, featuredMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit, response: response)
    }
}
