//
//  PRKReceiptBO.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 8/30/18.
//

import Foundation

public struct PRKReceiptBO {
    
    static var prkReceiptNS = PRKReceiptNS.shared
    
    private init() {}
    
    public static func confirmReceipt(receipt: String, subscription: Bool, email: String, params: AwesomeCoreNetworkServiceParams, response: @escaping (ErrorData?) -> Void) {
        prkReceiptNS.confirmReceipt(receipt: receipt, subscription: subscription, email: email, params: params) { error in
            DispatchQueue.main.async {
                response(error)
            }
        }
    }
    
    public static func user(withId id: String, params: AwesomeCoreNetworkServiceParams, response: @escaping (PRKUser?, ErrorData?) -> Void) {
        prkReceiptNS.user(withId: id, params: params) { (prkUser, errorData) in
            DispatchQueue.main.async {
                response(prkUser, errorData)
            }
        }
    }
    
    public static func productsForUser(withId id: String, params: AwesomeCoreNetworkServiceParams = .forcing, response: @escaping (PRKUser?, ErrorData?) -> Void) {
        prkReceiptNS.productsForUser(withId: id, params: params) { (prkUser, errorData) in
            DispatchQueue.main.async {
                response(prkUser, errorData)
            }
        }
    }
    
}
