//
//  QuestPurchaseBO.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/7/17.
//

import Foundation

public struct QuestPurchaseBO {
    
    static var questPurchaseNS = QuestPurchaseNS.shared
    
    private init() {}
    
    public static func verifyReceipt(_ receipt: String, response: @escaping (Bool, ErrorData?) -> Void) {
        questPurchaseNS.verifyReceipt(withReceipt: receipt) { (success, error) in
            DispatchQueue.main.async {
                response(success, error)
            }
        }
    }
    
    public static func addPurchase(withProductId productId: String, response: @escaping (Bool, ErrorData?) -> Void) {
        questPurchaseNS.addPurchase(withProductId: productId) { (success, error) in
            DispatchQueue.main.async {
                response(success, error)
            }
        }
    }
}
