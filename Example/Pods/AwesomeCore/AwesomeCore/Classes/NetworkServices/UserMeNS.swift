//
//  UserMeNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 11/09/17.
//

import Foundation

class UserMeNS: BaseNS {
    
    static var shared = UserMeNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    var userMeRequest: URLSessionDataTask?
    
    override init() {}
    
    func fetchUserMe(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (UserMe?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (UserMe?, ErrorData?) -> Void ) -> Bool {
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.userMeRequest = nil
                let userMe = UserMeMP.parseUserMeFrom(jsonObject)
                AwesomeCoreStorage.isMembership = userMe.isMembership
                response(userMe, nil)
                return true
            } else {
                self.userMeRequest = nil
                if let error = error {
                    response(nil, error)
                    return false
                }
                response(nil, ErrorData(.unknown, "response Data could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.shared.userMeURL
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        userMeRequest = awesomeRequester.performRequestAuthorized(url, forceUpdate: true) { (data, error, responseType) in
            if processResponse(data: data, error: error, response: response) {
                self.saveToCache(url, method: method, bodyDict: nil, data: data)
            }
        }
        
    }
    
}

