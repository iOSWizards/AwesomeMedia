//
//  QuestProductVariantDA.swift
//  AwesomeCore
//
//  Created by Antonio on 1/16/18.
//

//import Foundation
//
//class QuestProductVariantDA {
//    
//    // MARK: - Parser
//    
//    func parseToCoreData(_ questProductVariant: QuestProductVariant, result: @escaping (CDProductVariant) -> Void) {
//        AwesomeCoreDataAccess.shared.performInBackground {
//            let cdProductVariant = self.parseToCoreData(questProductVariant)
//            result(cdProductVariant)
//        }
//    }
//    
//    func parseToCoreData(_ questProductVariant: QuestProductVariant) -> CDProductVariant {
//        
//        guard let identifier = questProductVariant.identifier else {
//            fatalError("CDProductVariant object can't be created without identifier.")
//        }
//        let p = predicate(identifier, questProductVariant.productId ?? "")
//        let cdProductVariant = CDProductVariant.getObjectAC(predicate: p, createIfNil: true) as! CDProductVariant
//        
//        cdProductVariant.identifier = questProductVariant.identifier
//        cdProductVariant.type = questProductVariant.type
//        cdProductVariant.currency = questProductVariant.price.currency
//        cdProductVariant.price = questProductVariant.price.amount ?? 0
//        return cdProductVariant
//    }
//    
//    func parseFromCoreData(_ cdProductVariant: CDProductVariant) -> QuestProductVariant {
//        let price = QuestProductPrice(
//            currency: cdProductVariant.currency,
//            amount: cdProductVariant.price
//        )
//        return QuestProductVariant(
//            identifier: cdProductVariant.identifier,
//            price: price,
//            type: cdProductVariant.type,
//            productId: cdProductVariant.product?.id
//        )
//    }
//    
//    // MARK: - Fetch
//    
//    func loadBy(productVariantId: String, productId: String, result: @escaping (CDProductVariant?) -> Void) {
//        func perform() {
//            let p = predicate(productVariantId, productId)
//            guard let cdProductVariant = CDProductVariant.listAC(predicate: p).first as? CDProductVariant else {
//                result(nil); return
//            }
//            result(cdProductVariant)
//        }
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            perform()
//        })
//    }
//    
//    // MARK: - Helpers
//    
//    func extractCDProductVariants(_ questProductVariants: [QuestProductVariant]?) -> NSSet {
//        var variants = NSSet()
//        guard let questProductVariants = questProductVariants else { return variants }
//        for qpv in questProductVariants {
//            variants = variants.adding(parseToCoreData(qpv)) as NSSet
//        }
//        return variants
//    }
//    
//    func extractQuestVariants(_ cdQuestVariants: NSSet?) -> [QuestProductVariant] {
//        var variants = [QuestProductVariant]()
//        guard let cdProductVariants = cdQuestVariants else { return variants }
//        for qp in cdProductVariants {
//            variants.append(parseFromCoreData(qp as! CDProductVariant))
//        }
//        return variants
//    }
//    
//    private func predicate(_ productVariantId: String, _ productId: String) -> NSPredicate {
//        return NSPredicate(format: "identifier == %@ AND product.id == %@", productVariantId, productId)
//    }
//}

