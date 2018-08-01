//
//  UserMeNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 11/09/17.
//

import Foundation

class UserMeNS {
    
    static var shared = UserMeNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    var userMeRequest: URLSessionDataTask?
    
    init() {}
    
    func fetchUserMe(forcingUpdate: Bool = false, response: @escaping (UserMe?, ErrorData?) -> Void) {
        
        userMeRequest?.cancel()
        userMeRequest = nil
        
        userMeRequest = awesomeRequester.performRequestAuthorized(ACConstants.shared.userMeURL, forceUpdate: forcingUpdate) { (data, error, responseType) in
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.userMeRequest = nil
                let userMe = UserMeMP.parseUserMeFrom(jsonObject)
                AwesomeCoreStorage.isMembership = userMe.isMembership
                response(userMe, nil)
            } else {
                self.userMeRequest = nil
                if let error = error {
                    response(nil, error)
                    return
                }
                response(nil, ErrorData(.unknown, "response Data could not be parsed"))
            }
        }
        
    }
    
}

