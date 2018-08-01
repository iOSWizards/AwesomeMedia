//
//  ChannelsNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 16/05/18.
//

import Foundation

class ChannelsNS {
    
    static let shared = ChannelsNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var channelsRequest: URLSessionDataTask?
    var allChannelsRequest: URLSessionDataTask?
    
    func fetchChannelData(with academyId: Int, forcingUpdate: Bool = false, response: @escaping (ChannelData?, ErrorData?) -> Void) {
        
        channelsRequest?.cancel()
        channelsRequest = nil
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.channelsWithAcademy, with: academyId)
        
        channelsRequest = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: forcingUpdate, method: .GET, completion: { (data, error, responseType) in
                
                if let jsonObject = data {
                    self.channelsRequest = nil
                    response(ChannelsMP.parseChannelsFrom(jsonObject), nil)
                } else {
                    self.channelsRequest = nil
                    if let error = error {
                        response(nil, error)
                        return
                    }
                    response(nil, ErrorData(.unknown, "response Data for Member Benefits could not be parsed"))
                }
        })
    }
    
    func fetchAllChannels(forcingUpdate: Bool = false, response: @escaping ([AllChannels], ErrorData?) -> Void) {
        
        allChannelsRequest?.cancel()
        allChannelsRequest = nil
        
        allChannelsRequest = awesomeRequester.performRequestAuthorized(
            ACConstants.shared.channels, forceUpdate: forcingUpdate, method: .GET, completion: { (data, error, responseType) in
                
                if let jsonObject = data {
                    self.allChannelsRequest = nil
                    response(ChannelsMP.parseAllChannelsFrom(jsonObject), nil)
                } else {
                    self.allChannelsRequest = nil
                    if let error = error {
                        response([], error)
                        return
                    }
                    response([], ErrorData(.unknown, "response Data for Member Benefits could not be parsed"))
                }
        })
    }
}
