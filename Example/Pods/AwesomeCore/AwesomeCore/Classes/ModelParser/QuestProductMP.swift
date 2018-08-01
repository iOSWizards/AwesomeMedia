//
//  QuestProductMP.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/7/17.
//

import Foundation

struct QuestProductMP {
    
    static func parseQuestProductsFrom(_ QuestProductsJSON: Data) -> [QuestProduct] {
        
        var products: [QuestProduct] = []
        if let decoded = try? JSONDecoder().decode(QuestProductsDataKey.self, from: QuestProductsJSON) {
            products = decoded.data.products
        }
        
        return products
    }
    
    static func parseQuestProductFrom(_ QuestProductsJSON: Data) -> QuestProduct? {
        
        var questProduct: QuestProduct?
        if let decoded = try? JSONDecoder().decode(SingleQuestProductDataKey.self, from: QuestProductsJSON) {
            questProduct = decoded.data.product
        }
        
        return questProduct
    }
    
    static func parseQuestRedeemableProductsFrom(_ QuestProductsJSON: Data) -> [QuestProduct] {
        
        var products: [QuestProduct] = []
        if let decoded = try? JSONDecoder().decode(QuestRedeemableProductsDataKey.self, from: QuestProductsJSON) {
            products = decoded.data.redeemableProducts
        }
        
        return products
    }
    
}
