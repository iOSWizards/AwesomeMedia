//
//  AddSignupUserDetailsBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 29/03/18.
//

import Foundation

public struct AddSignupUserDetailsBO {
    
    static var addSignupDetailsNS = AddSignupUserDetailsNS.shared
    public static var shared = AddSignupUserDetailsBO()
    
    private init() {}
    
    public static func postAddUserDetails(withUid uid: String, email: String, authToken: String, deviceInfo: String, forcingUpdate: Bool = false, response: @escaping (Bool, ErrorData?) -> Void) {
        addSignupDetailsNS.postAddUserDetails(withUid: uid, email: email, authToken: authToken, deviceInfo: deviceInfo, forcingUpdate: forcingUpdate) { (success, error) in
            DispatchQueue.main.async {
                response(success, error)
            }
        }
    }
}
