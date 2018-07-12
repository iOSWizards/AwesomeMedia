//
//  QuizCategoriesMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 22/02/18.
//

import Foundation

struct QuizCategoriesMP {
    
    static func parseCategoriesFrom(_ categoriesJSON: Data) -> QuizCategories {
        
        if let decoded = try? JSONDecoder().decode(QuizCategories.self, from: categoriesJSON) {
            return decoded
        } else {
            return QuizCategories(categories: [])
        }
    }
    
}

