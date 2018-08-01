//
//  QuizCategoriesBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 22/02/18.
//

import Foundation

public struct QuizCategoriesBO {
    
    static var quizCategoriesNS = QuizCategoriesNS.shared
    public static var shared = QuizCategoriesBO()
    public var categoriesShared: [QuizCategory] = []
    
    private init() {}
    
    public static func fetchQuizCategories(forcingUpdate: Bool = false, response: @escaping ([QuizCategory], ErrorData?) -> Void) {
        quizCategoriesNS.fetchQuizCategories(forcingUpdate: forcingUpdate) { (categories, error) in
            DispatchQueue.main.async {
                QuizCategoriesBO.shared.categoriesShared = categories
                response(categories, error)
            }
        }
    }
}
