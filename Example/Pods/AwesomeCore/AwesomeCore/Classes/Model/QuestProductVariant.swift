//
//  QuestProductVariant.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/7/17.
//

import Foundation

public struct QuestProductVariant: Codable, Equatable {
    
    public let identifier: String?
    public let price: QuestProductPrice?
    public let type: String?
    public let productId: String?  // FK to the CDProduct   product.id
    
    init(identifier: String?, price: QuestProductPrice?, type: String?, productId: String? = nil) {
        self.identifier = identifier
        self.price = price
        self.type = type
        self.productId = productId
    }
    
}

// MARK: - JSON Key

public struct QuestProductVariants: Codable {
    
    public let variants: [QuestProductVariant]
    
}

// MARK: - Equatable

extension QuestProductVariant {
    
    public static func ==(lhs: QuestProductVariant, rhs: QuestProductVariant) -> Bool {
        if lhs.identifier != rhs.identifier {
            return false
        }
        if lhs.price != rhs.price {
            return false
        }
        if lhs.type != rhs.type {
            return false
        }
        if lhs.productId != rhs.productId {
            return false
        }
        return true
    }
}
