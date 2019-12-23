//
//  AcademyCategoryMP.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 30/01/19.
//

import Foundation

struct AcademyCategoryMP {
    
    static func parse(_ data: Data) -> [AcademyCategory] {
        do {
            let decoded = try JSONDecoder().decode(AcademyCategories.self, from: data)
            return decoded.categories
        } catch {
            print("\(#function) error: \(error)")
        }
        return []
    }
    
}
