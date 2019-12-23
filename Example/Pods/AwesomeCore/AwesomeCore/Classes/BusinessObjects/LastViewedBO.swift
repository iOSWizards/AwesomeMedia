//
//  LastViewedBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/09/17.
//

import Foundation

public struct LastViewedBO {
    
    static var lastViewedNS = LastViewedNS.shared
    
    private init() {}
    
    public static func fetchLastViewed(forcingUpdate: Bool = false, response: @escaping ([TrainingCard], ErrorData?) -> Void) {
        lastViewedNS.fetchLastViewed() { (lastViewed, error) in
            DispatchQueue.main.async {
                response(lastViewed, error)
            }
        }
    }
}

