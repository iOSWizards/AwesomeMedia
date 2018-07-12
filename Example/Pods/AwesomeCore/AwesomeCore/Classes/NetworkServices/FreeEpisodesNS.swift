//
//  FreeEpisodesNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 16/03/18.
//

import Foundation

class FreeEpisodesNS {
    
    static let shared = FreeEpisodesNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var freeEpisodesRequest: URLSessionDataTask?
    
    func fetchFreeEpisodes(forcingUpdate: Bool = false, response: @escaping ([FreeCourse], ErrorData?) -> Void) {
        
        freeEpisodesRequest?.cancel()
        freeEpisodesRequest = nil
        
        freeEpisodesRequest = awesomeRequester.performRequestAuthorized(
            ACConstants.shared.freeEpisodes, forceUpdate: forcingUpdate, completion: { (data, error, responseType) in
                
                if let jsonObject = data {
                    self.freeEpisodesRequest = nil
                    response(FreeEpisodesMP.parsefreeEpisodesFrom(jsonObject).courses, nil)
                } else {
                    self.freeEpisodesRequest = nil
                    if let error = error {
                        response([], error)
                        return
                    }
                    response([], ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
}

