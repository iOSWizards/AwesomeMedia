//
//  BubbleQuizCategories.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 25/02/19.
//

import Foundation

public struct BubbleQuizData: Codable {
    public let quiz: BubbleQuizDataFtu
}

public struct BubbleQuizDataFtu: Codable {
    public let categories: [BubbleQuizCategory]
}

public struct BubbleQuizCategories: Codable {
    public let data: BubbleQuizData
}

public struct BubbleQuizQuestions: Codable {
    public let title: String?
    public let id: String?
}

public struct BubbleQuizCategory: Codable {
    public let title: String?
    public let subtitle: String?
    public let name: String?
    public let id: String?
    public let icon: String?
    public let answers: [BubbleQuizQuestions]?
    
    public init(title: String? = nil, subtitle: String? = nil, name: String? = nil, id: String? = nil, icon: String? = nil, answers:[BubbleQuizQuestions]? = nil ) {
        self.title = title
        self.name = name
        self.id = id
        self.icon = icon
        self.answers = answers
        self.subtitle = subtitle
    }
}

// MARK: - Coding keys

extension BubbleQuizDataFtu {
    
    private enum CodingKeys: String, CodingKey {
        case categories = "questions"
    }
    
}

extension BubbleQuizData {
    
    private enum CodingKeys: String, CodingKey {
        case quiz = "ftuQuiz"
    }
    
}

