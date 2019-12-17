//
//  BubbleQuizCategoriesMP.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 25/02/19.
//

import Foundation

struct BubbleQuizCategoriesMP {
    
    static func parse(_ data: Data) -> [BubbleQuizCategory] {
        do {
            let decoded = try JSONDecoder().decode(BubbleQuizCategories.self, from: data)
            return decoded.data.quiz.categories
        } catch {
            print("\(#function) error: \(error)")
        }
        return []
    }
    
}
