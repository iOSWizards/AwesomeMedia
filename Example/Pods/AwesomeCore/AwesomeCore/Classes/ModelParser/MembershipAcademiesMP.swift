//
//  MembershipAcademiesMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 25/10/17.
//

struct MembershipAcademiesMP {
    
    static func parseMembershipAcademiesFrom(_ membershipAcademiesJSON: Data) -> [MembershipAcademy] {
        
        var academies: [MembershipAcademy] = []
        if let decoded = try? JSONDecoder().decode(MembershipAcademies.self, from: membershipAcademiesJSON) {
           academies = decoded.academies
        }
        
        return academies
    }
    
}
