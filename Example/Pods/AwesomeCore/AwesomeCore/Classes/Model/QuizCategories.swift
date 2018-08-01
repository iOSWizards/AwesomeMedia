//
//  QuizCategories.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 21/02/18.
//

import Foundation

public struct QuizCategories: Codable {
    public let categories: [QuizCategory]
}

public struct QuizCategory: Codable {
    
    public let id: Int
    public let categoryName: String
    public let coverUrl: String
    public let coverUrlMobile: String
    public let themeColor: String
    public var subCategories: [QuizSubcategories]
    
}

public struct QuizSubcategories: Codable {
    
    public let id: Int
    public let name: String
    
}

// MARK: - Coding keys

extension QuizCategory {
    private enum CodingKeys: String, CodingKey {
        case id
        case categoryName = "value"
        case coverUrl
        case coverUrlMobile
        case themeColor
        case subCategories
    }
}

extension QuizSubcategories {
    private enum CodingKeys: String, CodingKey {
        case id
        case name = "value"
    }
}

// MARK: - Equatable

extension QuizCategories {
    public static func ==(lhs: QuizCategories, rhs: QuizCategories) -> Bool {
        if lhs.categories.first?.id != rhs.categories.first?.id  {
            return false
        }
        return true
    }
}
