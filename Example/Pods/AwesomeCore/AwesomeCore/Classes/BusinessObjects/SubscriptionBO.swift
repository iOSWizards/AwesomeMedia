//
//  SubscriptionBO.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 11/09/2017.
//

import Foundation

public struct SubscriptionBO { // TODO: this class will be called LibraryBO in the end.
    
    static var subscriptionNS = SubscriptionNS.shared
    static var collectionNS = CollectionNS.shared
    
    private init() {}
    
    public static func fetchSubscriptions(forcingUpdate: Bool = false, response: @escaping ([Subscription], ErrorData?) -> Void) {
        subscriptionNS.fetchSubscriptions(forcingUpdate: forcingUpdate) { (subscriptions, error) in
            DispatchQueue.main.async {
                response(subscriptions, error)
            }
        }
    }
    
    public static func fetchCollections(forcingUpdate: Bool = false, response: @escaping ([ACCollection], ErrorData?) -> Void) {
        collectionNS.fetchCollections(forcingUpdate: forcingUpdate) { (collections, error) in
            DispatchQueue.main.async {
                response(collections, error)
            }
        }
    }
}
