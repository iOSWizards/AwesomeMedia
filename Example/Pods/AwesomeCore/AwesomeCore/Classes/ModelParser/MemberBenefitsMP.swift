//
//  MemberBenefitsMP.swift
//  AwesomeCore
//
//  Created by Emmanuel on 09/05/2018.
//

import Foundation

struct MemberBenefitsMP {
    
    static func parseMemberBenefitsFrom(_ memberBenefitsJson: Data) -> MemberBenefits {
        
        if let decoded = try? JSONDecoder().decode(MemberBenefits.self, from: memberBenefitsJson) {
            return decoded
        } else {
            return MemberBenefits(benefits: [])
        }
    }
    
}
