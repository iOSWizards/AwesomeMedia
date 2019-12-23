//
//  AwesomeCore+BubbleQuiz.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 25/02/19.
//

import Foundation

public extension AwesomeCore {
    
    public static func getBubbleQuizCategories(params: AwesomeCoreNetworkServiceParams, response: @escaping ([BubbleQuizCategory], ErrorData?) -> Void) {
        BubbleQuizCategoriesNS.shared.getCategories(params: params) { (categories, error) in
            DispatchQueue.main.async {
                response(categories, error)
            }
        }
    }
    
    public static func submitBubbleQuizResponse(answers: [Int], distinctId: String, cardLimit: Bool = false, params: AwesomeCoreNetworkServiceParams, response: @escaping (BubbleQuizSubmitAnswersResponse?, ErrorData?) -> Void) {
        BubbleQuizSubmitAnswersNS.shared.submitAnswers(answers: answers, distinctId: distinctId, cardLimit: cardLimit, params: .standard) { (answersResponse, error) in
            DispatchQueue.main.async {
                response(answersResponse, error)
            }
        }
    }
    
}

