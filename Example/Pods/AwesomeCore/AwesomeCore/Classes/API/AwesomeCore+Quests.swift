//
//  AwesomeCore+Quests.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 3/22/18.
//

import Foundation
import RealmSwift

public extension AwesomeCore {
    
    // MARK: - Quests
    
    public static func fetchQuests(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?) -> Void) {
        QuestBO.fetchQuests(params: params, response: response)
    }
    
    public static func fetchCommunities(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?) -> Void) {
        QuestBO.fetchCommunities(params: params, response: response)
    }
    
    public static func fetchQuest(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (Quest?, ErrorData?) -> Void) {
        QuestBO.fetchQuest(withId: id, params: params, response: response)
    }
    
    // MARK: - My Time
    
    public static func fetchMyTime(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?) -> Void) {
        QuestBO.fetchMyTime(params: params, response: response)
    }
    
    // MARK: - Quest Page
    
    public static func fetchQuestPage(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestPage?, ErrorData?) -> Void) {
        QuestPageBO.fetchQuestPage(withId: id, params: params, response: response)
    }
    
    // MARK: - Products
    
    public static func fetchProducts(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([QuestProduct], ErrorData?) -> Void) {
        QuestProductBO.fetchProducts(params: params, response: response)
    }
    
    public static func fetchProduct(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestProduct?, ErrorData?) -> Void) {
        QuestProductBO.fetchProduct(withId: id, params: params, response: response)
    }
    
    // MARK: - Content Mutations
    
    public static func markContentComplete(withId id: String, response: @escaping (ErrorData?) -> Void) {
        QuestBO.markContentComplete(withId: id, response: response)
    }
    
    public static func markTaskComplete(withId id: String, response: @escaping (ErrorData?) -> Void) {
        QuestBO.markTaskComplete(withId: id, response: response)
    }
    
    public static func updateTaskComplete(withId id: String, details: String, response: @escaping (ErrorData?) -> Void) {
        QuestBO.updateTaskComplete(withId: id, details: details, response: response)
    }
    
    public static func enrollUser(withId id: String, response: @escaping (ErrorData?) -> Void) {
        QuestBO.enrollUser(withId: id, response: response)
    }
    
    // MARK: - Purchases
    
    public static func verifyReceipt(_ receipt: String, response: @escaping (Bool, ErrorData?) -> Void) {
        QuestPurchaseBO.verifyReceipt(receipt, response: response)
    }
    
    public static func addPurchase(withProductId productId: String, response: @escaping (Bool, ErrorData?) -> Void) {
        QuestPurchaseBO.addPurchase(withProductId: productId, response: response)
    }
    
    // MARK: - User profile
    
    public static func fetchQuestUserProfile(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (UserProfile?, ErrorData?) -> Void) {
        UserProfileBO.fetchQuestUserProfile(params: params, response: response)
    }
    
}
