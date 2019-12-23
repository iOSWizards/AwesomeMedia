//
//  QuestProductGraphQLModel.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/7/17.
//

import Foundation

public struct QuestProductGraphQLModel {
    
    // MARK: - Model Sections
    
    // Product
    
    private static let productModel = "availableAt description featured redeemable comingSoon id discountRate questStartDate questEndDate name publishedAt purchased type questId imageAsset { \(QuestGraphQLModel.assetImageModel) } featuredAsset { \(QuestGraphQLModel.assetImageModel) } quest { \(QuestGraphQLModel.questModel) authors { \(QuestGraphQLModel.authorModel) } } variants { \(productVariantModel) } settings { \(QuestProductGraphQLModel.settingsModel) }"
   private static let productContentModel = "availableAt description featured redeemable comingSoon id discountRate questStartDate questEndDate name publishedAt purchased type questId imageAsset { \(QuestGraphQLModel.assetImageModel) } featuredAsset { \(QuestGraphQLModel.assetImageModel) } quest { \(QuestGraphQLModel.questModel) authors { \(QuestGraphQLModel.authorModel) } } pages { \(productPageModel) } variants { \(productVariantModel) } settings { \(QuestProductGraphQLModel.settingsModel) }"
    private static let productPageModel = "description id name position sections { \(QuestGraphQLModel.sectionModel) }"
    private static let productVariantModel = "identifier type price { \(priceModel) }"
    private static let priceModel = "amount currency"
    private static let settingsModel = "color salesPageUrl"
    
    // MARK: - Products Query
    
    private static let productsModel = "query {products (type:\"ios\") { \(productModel) } }"
    private static let redeemableProductsModel = "query {redeemableProducts (type:\"ios\") { \(productModel) } }"
    
    public static func queryProducts() -> [String: AnyObject] {
        return ["query": productsModel as AnyObject]
    }
    
    public static func queryRedeemableProducts() -> [String: AnyObject] {
        return ["query": redeemableProductsModel as AnyObject]
    }
    
    // MARK: - Single Product Query
    
    private static let singleProductModel = "query {product(id:%@) { \(productContentModel) } }"
    
    public static func querySingleProduct(withId id: String) -> [String: AnyObject] {
        return ["query": String(format: singleProductModel, arguments: [id]) as AnyObject]
    }
    
}

