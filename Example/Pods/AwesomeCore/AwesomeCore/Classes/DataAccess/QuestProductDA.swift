//
//  QuestProductDA.swift
//  AwesomeCore
//
//  Created by Antonio on 1/16/18.
//

//import Foundation
//
//class QuestProductDA {
//    
//    let productPageDA = QuestProductPageDA()
//    let productVariantDA = QuestProductVariantDA()
//    let questAssetDA = QuestAssetDA()
//    
//    // MARK: - Parser
//    
//    func parseToCoreData(_ questProduct: QuestProduct, result: @escaping (CDProduct) -> Void) {
//        AwesomeCoreDataAccess.shared.performInBackground {
//                        
//            guard let productId = questProduct.id else {
//                fatalError("CDProduct object can't be created without id.")
//            }
//            let p = self.predicate(productId)
//            let cdProduct = CDProduct.getObjectAC(predicate: p, createIfNil: true) as! CDProduct
//            
//            cdProduct.availableAt = questProduct.availableAt
//            cdProduct.about = questProduct.description
//            cdProduct.id = questProduct.id
//            cdProduct.questId = questProduct.questId
//            cdProduct.purchased = questProduct.purchased
//            cdProduct.name = questProduct.name
//            cdProduct.featured = questProduct.featured
//            cdProduct.pages = self.productPageDA.extractCDProductPages(questProduct.pages)
////            cdProduct.price = questProduct.price.amount ?? 0
////            cdProduct.priceCurrency = questProduct.price.currency
//            cdProduct.variants = self.productVariantDA.extractCDProductVariants(questProduct.variants)
//            cdProduct.publishedAt = questProduct.publishedAt
//            cdProduct.sku = questProduct.sku
//            cdProduct.type = questProduct.type
//            
//            if let imageAsset = questProduct.imageAsset {
//                cdProduct.imageAsset = self.questAssetDA.parseToCoreData(imageAsset, coreDataProperty: .cdProduct_imageAsset)
//            }
//            if let featuredAsset = questProduct.featuredAsset {
//                cdProduct.featuredAsset = self.questAssetDA.parseToCoreData(featuredAsset, coreDataProperty: .cdProduct_featuredAsset)
//            }
//            
//            result(cdProduct)
//        }
//    }
//    
////    func parseFromCoreData(_ cdProduct: CDProduct) -> QuestProduct {
////        let price = QuestProductPrice(
////            currency: cdProduct.priceCurrency, amount: cdProduct.price
////        )
////        var imageAsset: QuestAsset? {
////            guard let imageAsset = cdProduct.imageAsset else { return nil }
////            return questAssetDA.parseFromCoreData(imageAsset)
////        }
////        var featuredAsset: QuestAsset? {
////            guard let featuredAsset = cdProduct.featuredAsset else { return nil }
////            return questAssetDA.parseFromCoreData(featuredAsset)
////        }
////        return QuestProduct(
////            availableAt: cdProduct.availableAt,
////            description: cdProduct.about,
////            featured: cdProduct.featured,
////            id: cdProduct.id,
////            imageAsset: imageAsset,
////            featuredAsset: featuredAsset,
////            name: cdProduct.name,
////            pages: productPageDA.extractQuestProductPages(cdProduct.pages),
////            price: price,
////            publishedAt: cdProduct.publishedAt,
////            purchased: cdProduct.purchased,
////            questId: cdProduct.questId,
////            sku: cdProduct.sku,
////            type: cdProduct.type,
////            variants: productVariantDA.extractQuestVariants(cdProduct.variants),
////        )
////    }
//
//    // MARK: - Fetch
//
//    func loadBy(productId: String, result: @escaping (CDProduct?) -> Void) {
//        func perform() {
//            let p = predicate(productId)
//            guard let cdProduct = CDProduct.listAC(predicate: p).first as? CDProduct else {
//                result(nil); return
//            }
//            result(cdProduct)
//        }
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            perform()
//        })
//    }
//    
//    // MARK: - Helpers
//    
//    private func predicate(_ productId: String) -> NSPredicate {
//        return NSPredicate(format: "id == %@", productId)
//    }
//}
