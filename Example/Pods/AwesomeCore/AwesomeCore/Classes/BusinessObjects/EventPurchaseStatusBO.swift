//
//  EventPurchaseStatusBO.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 25/06/18.
//

import Foundation

public struct EventPurchaseStatusBO {
    
    static var purchaseStatusNS = EventPurchaseStatusNS.shared
    public static var shared = EventPurchaseStatusBO()
    
    private init() {}
    
    public static func fetchPurchaseStatus(eventSlug: EventCode = .mvu, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (Bool?, ErrorData?) -> Void) {
        purchaseStatusNS.fetchPurchaseStatus(eventSlug: eventSlug, params: params) { (status, error) in
            DispatchQueue.main.async {
                response(status, error)
            }
        }
    }
}
