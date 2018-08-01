//
//  UserMeMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 11/09/17.
//

import Foundation

struct UserMeMP {
    
    static func parseUserMeFrom(_ userMeJSON: [String: AnyObject]) -> UserMe {
        
        return UserMe.init(isMembership: AwesomeCoreParser.boolValue(userMeJSON, key: "isMindvalleyTribeMember"))
    }
    
}
