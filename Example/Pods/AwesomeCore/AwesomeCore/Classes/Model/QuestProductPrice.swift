//
//  QuestProductPrice.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/7/17.
//

import Foundation

public struct QuestProductPrice: Codable, Equatable {
    
    public let currency: String?
    public let amount: Double?
    
}

// MARK: - JSON Key

public struct QuestProductPriceKey: Codable {
    
    public let price: QuestProductPrice
    
}

// MARK: - Equatable

extension QuestProductPrice {
    
    public static func ==(lhs: QuestProductPrice, rhs: QuestProductPrice) -> Bool {
        if lhs.currency != rhs.currency {
            return false
        }
        if lhs.amount != rhs.amount {
            return false
        }
        return true
    }
}
