//
//  ForceUpdateNS.swift
//  Auth0-iOS10.0
//
//  Created by Maail on 03/04/2019.
//

import Foundation

class ForceUpdateNS: BaseNS {
    
    static let shared = ForceUpdateNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    func getForceUpdate(params: AwesomeCoreNetworkServiceParams, _ response:@escaping (FUVersionInfo?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (FUVersionInfo?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response(nil, nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            let forceUpdateData = ForceUpdateMP.parse(data)
            response(forceUpdateData, nil)
            return forceUpdateData != nil
        }
        
        let jsonBody: [String: AnyObject] = ForceUpdateGraphQLModel.queryForceUpdate()
        let method: URLMethod = .POST
        let url: String = ACConstants.shared.questsURL
        
        _ = requester.performRequest(url, method: method, forceUpdate: true, shouldCache: false, jsonBody: jsonBody, headers: ["x-mv-app" : "mv-ios"], timeoutAfter: AwesomeCore.timeoutTime) { (data, error, responseType) in
            
            _ = processResponse(data: data, error: error, response: response)
        }
    }
    
}
