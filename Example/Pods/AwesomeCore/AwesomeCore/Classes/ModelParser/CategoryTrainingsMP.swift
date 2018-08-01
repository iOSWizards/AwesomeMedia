//
//  CategoryTrainingsMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/09/17.
//

import Foundation

struct CategoryTrainingsMP {
    
    static func parseCategoryTrainingsFrom(_ categoryTrainingsJSON: [String: AnyObject]) -> CategoryTrainings {
        
        var subcategoriesArray: [String] = []
        if let subcategories = categoryTrainingsJSON["sub_categories"] as? [String] {
            for subcategory in subcategories {
                subcategoriesArray.append(subcategory)
            }
        }
        
        var trainingsArray: [TrainingCard] = []
        if let trainings = categoryTrainingsJSON["trainings"] as? [[String: AnyObject]] {
            for training in trainings {
                if let train = TrainingCardMP.parseTrainingCardFrom(training) {
                    trainingsArray.append(train)
                }
            }
        }
        
        return CategoryTrainings(subcategories: subcategoriesArray,
                                 trainings: trainingsArray)
    }
    
}
