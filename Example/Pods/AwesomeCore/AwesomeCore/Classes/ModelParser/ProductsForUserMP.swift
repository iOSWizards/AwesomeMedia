//
//  ProductsForUserMP.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 20/02/19.
//

import Foundation

struct ProductsForUserMP {
    
    static func parse(_ data: Data) -> ProductsForUser? {
        do {
            let decoded = try JSONDecoder().decode(ProductsForUser.self, from: data)
            return decoded
        } catch {
            print("\(#function) error: \(error)")
        }
        return nil
    }
    
}
