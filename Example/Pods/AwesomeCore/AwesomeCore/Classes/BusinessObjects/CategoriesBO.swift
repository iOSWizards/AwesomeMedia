//
//  CategoriesBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/09/17.
//

import Foundation

public struct CategoriesBO {
    
    static var categoriesNS = CategoriesNS.shared
    
    private init() {}
    
    public static func fetchCategories(forcingUpdate: Bool = false, response: @escaping ([ACCategory], ErrorData?) -> Void) {
        categoriesNS.fetchCategories(forcingUpdate: forcingUpdate) { (categories, error) in
            DispatchQueue.main.async {
                response(categories, error)
            }
        }
    }
}
