//
//  MemberBenefitsBO.swift
//  AwesomeCore
//
//  Created by Emmanuel on 09/05/2018.
//

import Foundation

public struct MemberBenefitsBO {
    
    static var memberBenefitsNS = MemberBenefitsNS.shared
    public static var shared = MemberBenefitsBO()
    
    private init() {}
    
    public static func fetchMemberBenefits(forcingUpdate: Bool = false, response: @escaping ([Benefits], ErrorData?) -> Void) {
        memberBenefitsNS.fetchMemberBenefits(forcingUpdate: forcingUpdate, response: { (benefits, error) in
            DispatchQueue.main.async {
                response(benefits, error)
            }
        })
    }
}
