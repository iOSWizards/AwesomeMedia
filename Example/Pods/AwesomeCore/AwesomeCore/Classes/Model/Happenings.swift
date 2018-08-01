//
//  Happenings.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 25/10/17.
//

import Foundation

public struct Happenings: Codable {
    
    public let happenings: [Happening]
    
}

public struct Happening: Codable {
    
    public let type: String
    public let title: String
    public let subtitle: String
    public let description: String
    public var startDate: String
    public let endDate: String
    public let buttonURL: String
    public let imageURL: String
    
}

// MARK: - Coding keys

extension Happening {
    private enum CodingKeys: String, CodingKey {
        case type
        case title
        case subtitle = "sub_title"
        case description
        case startDate = "start_date"
        case endDate = "end_date"
        case buttonURL = "button_url"
        case imageURL = "image_url"
    }
}

// MARK: - Equatable

extension Happenings {
    public static func ==(lhs: Happenings, rhs: Happenings) -> Bool {
        if lhs.happenings.first?.title != rhs.happenings.first?.title {
            return false
        }
        return true
    }
}
