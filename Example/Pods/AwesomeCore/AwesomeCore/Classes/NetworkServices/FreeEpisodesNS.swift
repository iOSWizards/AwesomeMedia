//
//  FreeEpisodesNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 16/03/18.
//

import Foundation

class FreeEpisodesNS: BaseNS {
    
    static let shared = FreeEpisodesNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    var freeEpisodesRequest: URLSessionDataTask?
    
    func fetchFreeEpisodes(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([FreeCourse], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([FreeCourse], ErrorData?) -> Void ) -> Bool {
            if let jsonObject = data {
                self.freeEpisodesRequest = nil
                response(FreeEpisodesMP.parsefreeEpisodesFrom(jsonObject).courses, nil)
                return true
            } else {
                self.freeEpisodesRequest = nil
                if let error = error {
                    response([], error)
                    return false
                }
                response([], ErrorData(.unknown, "response Data could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.shared.freeEpisodes
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        freeEpisodesRequest = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: nil, data: data)
                }
        })
    }
}

