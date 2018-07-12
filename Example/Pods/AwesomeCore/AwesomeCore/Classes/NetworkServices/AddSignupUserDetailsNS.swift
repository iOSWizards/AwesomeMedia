//
//  AddSignupUserDetailsNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 29/03/18.
//

import Foundation

class AddSignupUserDetailsNS {
    
    static let shared = AddSignupUserDetailsNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var addSignupUserDetailsRequest: URLSessionDataTask?
    
    func postAddUserDetails(withUid uid: String, email: String, authToken: String, deviceInfo: String, forcingUpdate: Bool = false, response: @escaping (Bool, ErrorData?) -> Void) {
        
        addSignupUserDetailsRequest?.cancel()
        addSignupUserDetailsRequest = nil
        
        let url = ACConstants.shared.addSignupDetails + "?uid=" + uid + "&email=" + email + "&auth_token=" + authToken + "&device_info=" + deviceInfo
        addSignupUserDetailsRequest = awesomeRequester.performRequestAuthorized(
            url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), forceUpdate: forcingUpdate, method: .POST, completion: { (data, error, responseType) in
                
                if error == nil {
                    self.addSignupUserDetailsRequest = nil
                    response(true, nil)
                } else {
                    self.addSignupUserDetailsRequest = nil
                    if let error = error {
                        response(false, error)
                        return
                    }
                    response(false, ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
}

