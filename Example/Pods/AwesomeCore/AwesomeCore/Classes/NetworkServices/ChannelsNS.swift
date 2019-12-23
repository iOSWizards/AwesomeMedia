//
//  ChannelsNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 16/05/18.
//

import Foundation

class ChannelsNS: BaseNS {
    
    static let shared = ChannelsNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    var channelsRequest: URLSessionDataTask?
    var allChannelsRequest: URLSessionDataTask?
    
    let method: URLMethod = .GET
    
    func fetchChannelData(with academyId: Int, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (ChannelData?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (ChannelData?, ErrorData?) -> Void ) -> Bool {
            if let jsonObject = data {
                self.channelsRequest = nil
                response(ChannelsMP.parseChannelsFrom(jsonObject), nil)
                return true
            } else {
                self.channelsRequest = nil
                if let error = error {
                    response(nil, error)
                    return false
                }
                response(nil, ErrorData(.unknown, "response Data for Member Benefits could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.channelsWithAcademy, with: academyId)
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        channelsRequest = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, method: method, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: self.method, bodyDict: nil, data: data)
                }
        })
    }
    
    func fetchAllChannels(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([AllChannels], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([AllChannels], ErrorData?) -> Void ) -> Bool {
            if let jsonObject = data {
                self.allChannelsRequest = nil
                response(ChannelsMP.parseAllChannelsFrom(jsonObject), nil)
                return true
            } else {
                self.allChannelsRequest = nil
                if let error = error {
                    response([], error)
                    return false
                }
                response([], ErrorData(.unknown, "response Data for Member Benefits could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.shared.channels
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        allChannelsRequest = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, method: method, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: self.method, bodyDict: nil, data: data)
                }
        })
    }
}
