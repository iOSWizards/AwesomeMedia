//
//  PRKPurchase.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 8/30/18.
//

import Foundation

public struct PRKPurchase: Codable {
    
    public let productId: Int?
    public let createdAt: String?
    public let iapReceiptId: Int?
    
    // MARK: - Coding keys
    
    private enum CodingKeys: String, CodingKey {
        case productId = "product_id"
        case createdAt = "created_at"
        case iapReceiptId = "in_app_purchase_receipt_id"
    }
}
