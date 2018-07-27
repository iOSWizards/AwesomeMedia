//
//  PurchaseStatusBO.swift
//  AwesomeCore-iOS10.0
//
//  Created by Emmanuel on 16/07/2018.
//

import Foundation

public struct PurchaseStatusBO {
    
    static var purchaseStatusNS = PurchaseStatusNS.shared
    public static var shared = PurchaseStatusBO()
    
    private init() {}
    
    public static func fetchPurchaseStatus(eventSlug: EventCode = .mvu, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (PurchaseStatus?, ErrorData?) -> Void) {
        purchaseStatusNS.fetchPurchaseStatus(eventSlug: eventSlug, params: params) { (status, error) in
            DispatchQueue.main.async {
                response(status, error)
            }
        }
    }
}
