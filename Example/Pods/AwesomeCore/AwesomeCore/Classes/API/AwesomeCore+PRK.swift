//
//  AwesomeCore+PRK.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 8/30/18.
//

import Foundation
import RealmSwift

public extension AwesomeCore {
    
    public static func confirmPrkReceipt(receipt: String, subscription: Bool, email: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (ErrorData?) -> Void) {
        PRKReceiptBO.confirmReceipt(receipt: receipt, subscription: subscription, email: email, params: params, response: response)
    }
    
    public static func prkUser(withId id: String, params: AwesomeCoreNetworkServiceParams = .forcing, response: @escaping (PRKUser?, ErrorData?) -> Void) {
        PRKReceiptBO.user(withId: id, params: params, response: response)
    }
}
