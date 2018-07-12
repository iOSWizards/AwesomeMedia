//
//  CommunityNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 31/01/18.
//

import Foundation

class CommunityNS {
    
    static let shared = CommunityNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var lastCommunityRequest: URLSessionDataTask?
    
    func fetchCommunities(forcingUpdate: Bool = false, response: @escaping (Communities, ErrorData?) -> Void) {
        
        lastCommunityRequest?.cancel()
        lastCommunityRequest = nil
        
        lastCommunityRequest = awesomeRequester.performRequestAuthorized(
            ACConstants.shared.communities, forceUpdate: forcingUpdate, completion: { (data, error, responseType) in
                
                if let jsonObject = data {
                    self.lastCommunityRequest = nil
                    
                    // parse and save communities
                    let communities = CommunityMP.parseCommunitiesFrom(jsonObject).communities
                    
                    response(communities, nil)
                } else {
                    self.lastCommunityRequest = nil
                    if let error = error {
                        response(Communities(publicGroups: [], tribeMembership: [], privateGroups: []), error)
                        return
                    }
                    response(Communities(publicGroups: [], tribeMembership: [], privateGroups: []), ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
}

