//
//  UserMeBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 11/09/17.
//

import Foundation

public struct UserMeBO {
    
    static var userMeNS = UserMeNS.shared
    
    private init() {}
    
    public static func fetchUserMe(forcingUpdate: Bool = false, response: @escaping (UserMe?, ErrorData?) -> Void) {
        userMeNS.fetchUserMe() { (user, error) in
            DispatchQueue.main.async {
                response(user, error)
            }
        }
    }
    
    public static func isMembership() -> Bool {
        return AwesomeCoreStorage.isMembership
    }
}
