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
    
    static func fetchQuests(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?, AwesomeResponseType) -> Void) {
        QuestBO.fetchQuests(params: params, response: response)
    }
    
    static func fetchQuests(by progress: QuestProgress, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?, AwesomeResponseType) -> Void) {
        QuestBO.fetchQuests(by: progress, params: params, response: response)
    }
    
    static func fetchQuestCommunities(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?) -> Void) {
        QuestBO.fetchCommunities(params: params, response: response)
    }
    
    static func fetchSpotlightQuests(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?, AwesomeResponseType) -> Void) {
        QuestBO.fetchSpotlightQuests(params: params, response: response)
    }
    
    static func fetchQuest(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (Quest?, ErrorData?) -> Void) {
        QuestBO.fetchQuest(withId: id, params: params, response: response)
    }
    
    static func fetchQuestIntakes(withId id: String, releaseStatus: String, releaseLimit: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestIntake?, ErrorData?) -> Void) {
        QuestBO.fetchQuestIntakes(withId: id, releaseStatus: releaseStatus, releaseLimit: releaseLimit, params: params, response: response)
    }
    
    // MARK: - My Time
    
    static func fetchMyTime(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Quest], ErrorData?, AwesomeResponseType) -> Void) {
        QuestBO.fetchMyTime(params: params, response: response)
    }
    
    // MARK: - Quest Page
    
    static func fetchQuestPage(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestPage?, ErrorData?) -> Void) {
        QuestPageBO.fetchQuestPage(withId: id, params: params, response: response)
    }
    
    // MARK: - Products
    
    static func fetchProducts(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([QuestProduct], ErrorData?) -> Void) {
        QuestProductBO.fetchProducts(params: params, response: response)
    }
    
    static func fetchProduct(withId id: String, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (QuestProduct?, ErrorData?) -> Void) {
        QuestProductBO.fetchProduct(withId: id, params: params, response: response)
    }
    
    // MARK: - Content Mutations
    
    static func markContentComplete(withId id: String, response: @escaping (ErrorData?) -> Void) {
        QuestBO.markContentComplete(withId: id, response: response)
    }
    
    static func markTaskComplete(withId id: String, response: @escaping (ErrorData?) -> Void) {
        QuestBO.markTaskComplete(withId: id, response: response)
    }
    
    static func updateTaskComplete(withId id: String, details: String, response: @escaping (ErrorData?) -> Void) {
        QuestBO.updateTaskComplete(withId: id, details: details, response: response)
    }
    
    static func enrollUser(withId id: String, response: @escaping (ErrorData?) -> Void) {
        QuestBO.enrollUser(withId: id, response: response)
    }
    
    static func enrollUserRelease(withId id: String, releaseId: String, response: @escaping (ErrorData?) -> Void) {
        QuestNS.shared.enrollUserRelease(withId: id, releaseId: releaseId, response: response)
    }
    
    // MARK: - Purchases
    
    static func verifyReceipt(_ receipt: String, response: @escaping (Bool, ErrorData?) -> Void) {
        QuestPurchaseBO.verifyReceipt(receipt, response: response)
    }
    
    static func addPurchase(withProductId productId: String, response: @escaping (Bool, ErrorData?) -> Void) {
        QuestPurchaseBO.addPurchase(withProductId: productId, response: response)
    }
    
    // MARK: - User profile
    
    static func fetchQuestUserProfile(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (UserProfile?, ErrorData?) -> Void) {
        UserProfileBO.fetchQuestUserProfile(params: params, response: response)
    }
    
}
