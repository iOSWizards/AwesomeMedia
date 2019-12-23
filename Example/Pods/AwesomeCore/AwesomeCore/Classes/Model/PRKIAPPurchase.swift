//
//  PRKIAPPurchase.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 9/4/18.
//

import Foundation

public enum StoreIdentifier {
    case google_play_store
    case apple_app_store
}

public struct PRKIAPPurchase: Codable {
    
    public let productId: Int?
    public let purchaseId: String?
    public let subscription: Bool?
    public let fullBundleIdentifier: String?
    public let storeName: String?
    public let purchaseDateTimeInMs: String?
    public let expiryDateTimeInMs: String?
    
    // MARK: - Coding keys
    
    private enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case purchaseId = "purchase_id"
        case subscription
        case fullBundleIdentifier = "full_bundle_identifier"
        case storeName = "store_name"
        case purchaseDateTimeInMs = "purchase_date_time_in_ms"
        case expiryDateTimeInMs = "expiry_date_time_in_ms"
    }
    
    public func purchasedStore() -> StoreIdentifier?{
        switch self.storeName {
        case "google_play_store":
            return .google_play_store
        case "apple_app_store":
            return .apple_app_store
        default:
            return nil
        }
    }
}
