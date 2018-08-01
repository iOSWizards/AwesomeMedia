//
//  MembershipAcademies.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 25/10/17.
//

import Foundation

public struct MembershipAcademies: Codable {
    
    public let academies: [MembershipAcademy]
    
}

public struct MembershipAcademy: Codable {
    
    public let id: Int
    public let title: String
    public let description: String
    public let domainURL: String
    public let isDisplayingRating: Bool
    
}

// MARK: - Coding keys

extension MembershipAcademy {
    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case domainURL = "domain"
        case isDisplayingRating = "display_rating"
    }
}

// MARK: - Equatable

extension MembershipAcademies {
    public static func ==(lhs: MembershipAcademies, rhs: MembershipAcademies) -> Bool {
        if lhs.academies.first?.id != rhs.academies.first?.id {
            return false
        }
        return true
    }
}

extension MembershipAcademy {
    public static func ==(lhs: MembershipAcademy, rhs: MembershipAcademy) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.title != rhs.title {
            return false
        }
        if lhs.description != rhs.description {
            return false
        }
        if lhs.domainURL != rhs.domainURL {
            return false
        }
        if lhs.isDisplayingRating != rhs.isDisplayingRating {
            return false
        }
        return true
    }
}
