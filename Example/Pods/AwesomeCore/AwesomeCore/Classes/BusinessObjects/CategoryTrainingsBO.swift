//
//  CategoryTrainingsBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/09/17.
//

import Foundation

public struct CategoryTrainingsBO {
    
    static var categoryTrainingsNS = CategoryTrainingsNS.shared
    
    private init() {}
    
    public static func fetchCategoryTrainings(withCategory category: String, forcingUpdate: Bool = false, response: @escaping (CategoryTrainings?, ErrorData?) -> Void) {
        categoryTrainingsNS.fetchCategoryTrainings(withCategory: category, forcingUpdate: forcingUpdate) { (categoryTrainings, error) in
            DispatchQueue.main.async {
                response(categoryTrainings, error)
            }
        }
    }
}

