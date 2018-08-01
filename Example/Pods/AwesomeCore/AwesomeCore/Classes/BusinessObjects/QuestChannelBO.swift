//
//  QuestChannelBO.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 7/23/18.
//

import Foundation

public struct QuestChannelBO {
    
    static var questChannelNS = QuestChannelNS.shared
    //static var questDA = QuestDA()
    
    private init() {}
    
    public static func fetchChannels(params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int, latestMediaLimit: Int, response: @escaping ([QuestChannel], ErrorData?) -> Void) {
        
        func sendResponse(_ channels: [QuestChannel], _ error: ErrorData?) {
            DispatchQueue.main.async { response(channels, error) }
        }
        
        func fetchFromAPI() {
            questChannelNS.fetchChannels(params: params, featuredMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit) { (channels, error) in
                sendResponse(channels, error)
            }
        }
        
        fetchFromAPI()
    }
    
    public static func fetchChannel(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, featuredMediaLimit: Int, latestMediaLimit: Int, response: @escaping (QuestChannel?, ErrorData?) -> Void) {
        func sendResponse(_ channel: QuestChannel?, _ error: ErrorData?) {
            DispatchQueue.main.async { response(channel, error) }
        }
        
        func fetchFromAPI() {
            questChannelNS.fetchChannel(withId: id, params: params, featuredMediaLimit: featuredMediaLimit, latestMediaLimit: latestMediaLimit) { (channel, error) in
                DispatchQueue.main.async {
                    response(channel, error)
                }
            }
        }
        
        fetchFromAPI()
    }

}
