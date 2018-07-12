//
//  QuestProductBO.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/7/17.
//

import Foundation

public struct QuestProductBO {
    
    static var questProductNS = QuestProductNS.shared
    
    private init() {}
    
    public static func fetchProducts(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([QuestProduct], ErrorData?) -> Void) {
        questProductNS.fetchProducts(params: params) { (products, error) in
            DispatchQueue.main.async {
                response(products, error)
            }
        }
    }
    
    public static func fetchProduct(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestProduct?, ErrorData?) -> Void) {
        questProductNS.fetchProduct(withId: id, params: params) { (product, error) in
            DispatchQueue.main.async {
                response(product, error)
            }
        }
    }
    
    public static func fetchRedeemableProducts(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([QuestProduct], ErrorData?) -> Void) {
        questProductNS.fetchRedeemableProducts(params: params) { (products, error) in
            DispatchQueue.main.async {
                response(products, error)
            }
        }
    }
    
}
