//
//  BubbleQuizGraphQLModel.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 25/02/19.
//

import Foundation

public struct BubbleQuizGraphQLModel {
    
    fileprivate static let cardModel = "id subtitle title description position type media{id title author { id name } type channel { id title }} settings { start_date theme_color icon } content_asset {id duration contentType filesize url renditions(labels: [\"mp4\", \"hls\"]) {id url status}  captions {id is_default label language url} } small_cover_asset { url }  large_cover_asset { url }"
    fileprivate static let quizCategoriesModelSrt: String = "{ ftuQuiz(id: 1) { id title subtitle questions{ id icon name title subtitle answers{ id title } } } }"
    
    static func quizCategoriesModel() -> [String: AnyObject] {
        return ["query": BubbleQuizGraphQLModel.quizCategoriesModelSrt as AnyObject]
    }
    
    // MARK: - Update bubble answers mutation
    
    fileprivate static var cardLimitText: String = ", cardLimit: 3"
    
    fileprivate static let mutateSubmitAnswers = "mutation { submitQuizResponse(distinctId: \"%@\", answers: [%@]%@){ startedAt, cards{ \(cardModel) }, currentCard{ \(cardModel) } } }"
    
    public static func submitAnswers(_ distinctId: String, answerIds: [Int], cardLimit: Bool = false) -> [String: AnyObject] {
        var ids: String = ""
        for id in answerIds {
            ids.append(contentsOf: ",\(id)")
        }
        let limit: String = cardLimit ? cardLimitText : ""
        return ["query": String(format: mutateSubmitAnswers, arguments: [distinctId, ids, limit]) as AnyObject]
    }
    
    // MARK: - User Journey Model
    
    private static let journeyModel = "{ journey(identifier: \"%@\"%@){ startedAt, cards{ \(cardModel) }, currentCard{ \(cardModel) } } }"
    
    public static func queryUserJourney(withIdentifier id: String, cardLimit: Bool = false) -> [String: AnyObject] {
        let limit: String = cardLimit ? cardLimitText : ""
        return ["query": String(format: journeyModel, arguments: [id, limit]) as AnyObject]
    }
    
}
