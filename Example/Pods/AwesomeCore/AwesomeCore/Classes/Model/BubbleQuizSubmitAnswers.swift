//
//  BubbleQuizSubmitAnswers.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 28/02/19.
//

import Foundation

public struct BubbleQuizSubmitAnswers: Codable {
    
    public let data: BubbleQuizSubmitAnswersData?
    
}

public struct BubbleQuizSubmitAnswersData: Codable {
    public let submitQuizResponse: BubbleQuizSubmitAnswersResponse?
}

public struct BubbleQuizSubmitAnswersResponse: Codable {
    
    public let startedAt: String?
    public let currentCard: TodayCard?
    public var cards: [TodayCard]?
    
}
