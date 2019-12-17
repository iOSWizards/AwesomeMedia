//
//  PRKUser.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 8/30/18.
//

import Foundation

public struct PRKUser: Codable {
    
    public let id: Int?
    public let uid: String?
    public let email: String?
    public let createdAt: String?
    public var productIds: [Int]?
    public let purchases: [PRKPurchase]?
    public let inAppPurchaseReceipts: [PRKIAPPurchase]?
    
    // MARK: - Coding keys
    
    private enum CodingKeys: String, CodingKey {
        case id
        case uid
        case email
        case createdAt = "created_at"
        case productIds = "product_ids"
        case purchases
        case inAppPurchaseReceipts = "in_app_purchase_receipts"
    }
    
    // Computed properties
    
    public func hasPurchase(withProductIds ids: [Int]) -> Bool {
        guard let productIds = productIds else {
            return false
        }
        
        for id in ids {
            if productIds.contains(id) {
                return true
            }
        }
        
        return false
    }
    
    public func hasIAPPurchase(withIdentifier identifier: String) -> Bool {
        guard let purchases = inAppPurchaseReceipts else {
            return false
        }
        
        for purchase in purchases where purchase.fullBundleIdentifier == identifier {
            return true
        }
        
        return false
    }
    
    public func hasIAPPurchase(withIdentifiers identifiers: [String]) -> Bool {
        guard let purchases = inAppPurchaseReceipts else {
            return false
        }
        
        for purchase in purchases {
            if let fullBundleIdentifier = purchase.fullBundleIdentifier{
                if identifiers.contains(fullBundleIdentifier){
                    return true
                }
            }
        }
        
        return false
    }
    
    public func hasIAPPurchase(withProductIds ids: [Int]) -> Bool {
        guard let purchases = inAppPurchaseReceipts else {
            return false
        }
        
        for id in ids {
            if productIds?.contains(id) ?? false {
                return true
            }
            
            for purchase in purchases where purchase.productId == id {
                return true
            }
        }
        
        return false
    }
    
    public func getIAPPurchaseDetails(forIdentifier identifier: String) -> PRKIAPPurchase? {
        guard let purchases = inAppPurchaseReceipts else {
            return nil
        }
        
        for purchase in purchases where purchase.fullBundleIdentifier == identifier {
            return purchase
        }
        
        return nil
    }
    
    public func getSubscriptionDates(forIdentifier identifier: String) -> (purchaseDate: Date, expiryDate: Date)? {
        
        if let purchase = self.getIAPPurchaseDetails(forIdentifier: identifier), let purchaseStartDate = Int(purchase.purchaseDateTimeInMs ?? "0"), let expiryDate = Int(purchase.expiryDateTimeInMs ?? "0") {
            let purchaseDate = Date(milliseconds: purchaseStartDate)
            let expiryDate = Date(milliseconds: expiryDate)
            return(purchaseDate, expiryDate)
        }
        
        return nil
    }
}

// MARK: - JSON Key

public struct PRKUserKey: Codable {
    
    public let user: PRKUser
    
}
