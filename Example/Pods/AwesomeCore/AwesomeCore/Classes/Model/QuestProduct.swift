//
//  QuestProduct.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/7/17.
//

import Foundation

public struct QuestProduct: Codable, Equatable {
    
    public let availableAt: String?
    public let description: String?
    public let featured: Bool
    public let id: String?
    public let imageAsset: QuestAsset?
    public let featuredAsset: QuestAsset?
    public let name: String?
    public let pages: [QuestProductPage]?
    public let price: QuestProductPrice?
    public let publishedAt: String?
    public var purchased: Bool
    public let questId: String?
    public let sku: String?
    public let type: String?
    public let variants: [QuestProductVariant]?
    public var redeemable: Bool?
    public var comingSoon: Bool?
    public let discountRate: Double?
    public let questStartDate: String?
    public let questEndDate: String?
    public let quest: Quest?
    public let settings: QuestProductSettings?
    
    // MARK: - Computed properties
    
    public var isFree: Bool {
        return price?.amount == 0
    }
    
    public var isFeatured: Bool {
        return featured && !(redeemable ?? false)
    }
    
    public var isComingSoon: Bool {
        return (comingSoon ?? false)
    }
    
    public var isRedeemable: Bool {
        return (redeemable ?? false)
    }
    
    public var isAvailable: Bool {
        return !isRedeemable && !isComingSoon && !isFeatured
    }
    
    public var startDay: String {
        return availableAt?.date?.toString(format: "dd") ?? ""
    }
    
    public var startMonth: String {
        return availableAt?.date?.toString(format: "MMM") ?? ""
    }
    
    public var iOSVariant: QuestProductVariant? {
        guard let variants = variants else {
            return nil
        }
        
        for variant in variants where variant.type == "ios" {
            return variant
        }
        
        return nil
    }
    
    public var discount: Double {
        guard let discountRate = discountRate else {
            return 0
        }
        
        return discountRate/100
    }
    
}

// MARK: - JSON Key

public struct QuestProductsDataKey: Codable {
    
    public let data: QuestProductsKey
    
}

public struct QuestProductsKey: Codable {
    
    public let products: [QuestProduct]
    
}

public struct SingleQuestProductDataKey: Codable {
    
    public let data: SingleQuestProductKey
    
}

public struct SingleQuestProductKey: Codable {
    
    public let product: QuestProduct
    
}

public struct QuestRedeemableProductsDataKey: Codable {
    
    public let data: QuestRedeemableProductsKey
    
}

public struct QuestRedeemableProductsKey: Codable {
    
    public let redeemableProducts: [QuestProduct]
    
}

// MARK: - Equatable

extension QuestProduct {
    public static func ==(lhs: QuestProduct, rhs: QuestProduct) -> Bool {
        if lhs.availableAt != rhs.availableAt {
            return false
        }
        if lhs.description != rhs.description {
            return false
        }
        if lhs.featured != rhs.featured {
            return false
        }
        if lhs.id != rhs.id {
            return false
        }
        if lhs.imageAsset != rhs.imageAsset {
            return false
        }
        if lhs.featuredAsset != rhs.featuredAsset {
            return false
        }
        if lhs.name != rhs.name {
            return false
        }
        if !Utility.equals(lhs.pages, rhs.pages) {
            return false
        }
        if lhs.price != rhs.price {
            return false
        }
        if lhs.publishedAt != rhs.publishedAt {
            return false
        }
        if lhs.purchased != rhs.purchased {
            return false
        }
        if lhs.questId != rhs.questId {
            return false
        }
        if lhs.sku != rhs.sku {
            return false
        }
        if lhs.type != rhs.type {
            return false
        }
        if !Utility.equals(lhs.variants, rhs.variants) {
            return false
        }
        if lhs.redeemable != rhs.redeemable {
            return false
        }
        if lhs.comingSoon != rhs.comingSoon {
            return false
        }
        if lhs.discountRate != rhs.discountRate {
            return false
        }
        if lhs.questStartDate != rhs.questStartDate {
            return false
        }
        if lhs.questEndDate != rhs.questEndDate {
            return false
        }
        if lhs.quest != rhs.quest {
            return false
        }
        
        return true
    }
}
