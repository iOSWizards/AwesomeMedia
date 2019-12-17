//
//  ChannelCategoriesNS.swift
//  Auth0-iOS10.0
//
//  Created by Maail on 24/05/2019.
//

import Foundation

class ChannelCategoriesNS: BaseNS {
    
    static let shared = ChannelCategoriesNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    func getChannelCategories(params: AwesomeCoreNetworkServiceParams, _ response:@escaping ([ChannelCategory]?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([ChannelCategory]?, ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response(nil, nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response(nil, error)
                return false
            }
            
            let categories = ChannelCategoriesMP.parse(data)
            response(categories, nil)
            return categories != nil
        }
        
        let jsonBody: [String: AnyObject] = ChannelCategoriesGraphQLModel.queryChannelCategories()
        let method: URLMethod = .POST
        let url: String = ACConstants.shared.questsURL
        
        _ = requester.performRequest(url, method: method, forceUpdate: true, shouldCache: false, jsonBody: jsonBody, headers: [:], timeoutAfter: AwesomeCore.timeoutTime) { (data, error, responseType) in
            _ = processResponse(data: data, error: error, response: response)
        }
    }
    
}
