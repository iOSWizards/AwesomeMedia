//
//  QuestReceiptGraphQLModel.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/7/17.
//

import Foundation

public struct QuestPurchaseGraphQLModel {
    
    // MARK: - Add Purchase Mutation
    
    private static let addPurchaseModel = "mutation { addPurchase(productId: \"%@\", source: \"ios\") { id product { id purchased } } }"
    
    public static func mutateAddPurchase(withId id: String) -> [String: AnyObject] {
        return ["query": String(format: addPurchaseModel, arguments: [id]) as AnyObject]
    }
    
    // MARK: - Verify Receipt Mutation
    
    private static let verifyIAPReceiptModel = "mutation { verifyIapReceipt(receipt: \"%@\", type: \"app_store\") { id } }"
    
    public static func mutateVerifyIAPReceipt(_ receipt: String) -> [String: AnyObject] {
        return ["query": String(format: verifyIAPReceiptModel, arguments: [receipt]) as AnyObject]
    }
}
