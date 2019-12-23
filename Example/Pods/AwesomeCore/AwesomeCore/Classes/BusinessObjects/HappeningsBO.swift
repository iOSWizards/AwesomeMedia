//
//  HappeningsBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 26/10/17.
//

import Foundation

public struct HappeningsBO {
    
    static var happeningsNS = HappeningsNS.shared
    
    private init() {}
    
    public static func fetchHappenings(forcingUpdate: Bool = false, response: @escaping ([Happening], ErrorData?) -> Void) {
        happeningsNS.fetchHappenings() { (happenings, error) in
            DispatchQueue.main.async {
                response(happenings, error)
            }
        }
    }
}
