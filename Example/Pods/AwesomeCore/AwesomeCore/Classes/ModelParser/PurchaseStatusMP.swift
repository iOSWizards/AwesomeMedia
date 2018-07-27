//
//  PurchaseStatusMP.swift
//  AwesomeCore-iOS10.0
//
//  Created by Emmanuel on 16/07/2018.
//

import Foundation

struct PurchaseStatusMP {
    
    static func parsePurchaseStatusFrom(_ purchaseStatusJSON: Data) -> PurchaseStatus? {
        
        var purchaseStatus: PurchaseStatus?
        if let decoded = try? JSONDecoder().decode(PurchaseStatus.self, from: purchaseStatusJSON) {
            purchaseStatus = decoded
        }
        
        return purchaseStatus
    }
    
}
