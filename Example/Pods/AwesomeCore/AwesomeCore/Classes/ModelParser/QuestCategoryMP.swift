//
//  QuestCategoryCategoryMP.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/3/17.
//

import Foundation

struct QuestCategoryMP {
    
    static func parseQuestCategoriesFrom(_ QuestCategoriesJSON: Data) -> [QuestCategory] {
        
        var categories: [QuestCategory] = []
        if let decoded = try? JSONDecoder().decode(QuestCategories.self, from: QuestCategoriesJSON) {
            categories = decoded.categories
        }
        
        return categories
    }
    
}
