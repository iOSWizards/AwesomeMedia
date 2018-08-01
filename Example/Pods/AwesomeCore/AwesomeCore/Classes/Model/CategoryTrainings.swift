//
//  CategoryTrainings.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/09/17.
//

import Foundation

public struct CategoryTrainings: Codable {
    
    public let subcategories: [String]
    public let trainings: [TrainingCard]
    
    init(subcategories: [String],
         trainings: [TrainingCard]) {
        
        self.subcategories = subcategories
        self.trainings = trainings
    }
}
