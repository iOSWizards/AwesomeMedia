//
//  QuestProductPageDA.swift
//  AwesomeCore
//
//  Created by Antonio on 1/15/18.
//

//import Foundation
//
//class QuestProductPageDA {
//    
//    let questSectionDA = QuestSectionDA()
//    
//    // MARK: - Parser
//    
//    func parseToCoreData(_ questProductPage: QuestProductPage, result: @escaping (CDProductPage) -> Void) {
//        AwesomeCoreDataAccess.shared.performInBackground {
//            let cdProductPage = self.parseToCoreData(questProductPage)
//            result(cdProductPage)
//        }
//    }
//    
//    func parseToCoreData(_ questProductPage: QuestProductPage) -> CDProductPage {
//        
//        guard let productPageId = questProductPage.id else {
//            fatalError("CDProductPage object can't be created without id.")
//        }
//        let p = predicate(productPageId, questProductPage.productId ?? "")
//        let cdProductPage = CDProductPage.getObjectAC(predicate: p, createIfNil: true) as! CDProductPage
//        
//        cdProductPage.id = questProductPage.id
//        cdProductPage.about = questProductPage.description
//        cdProductPage.name = questProductPage.name
//        cdProductPage.position = Int16(questProductPage.position)
//        cdProductPage.sections = self.questSectionDA.extractCDSections(questProductPage.sections)
//        return cdProductPage
//    }
//    
//    func parseFromCoreData(_ cdProductPage: CDProductPage) -> QuestProductPage {
//        return QuestProductPage(
//            description: cdProductPage.about,
//            id: cdProductPage.id,
//            name: cdProductPage.name,
//            position: Int(cdProductPage.position),
//            sections: questSectionDA.extractQuestSections(cdProductPage.sections),
//            productId: cdProductPage.product?.id
//        )
//    }
//    
//    // MARK: - Fetch
//    
//    func loadBy(productPageId: String, productId: String, result: @escaping (CDProductPage?) -> Void) {
//        func perform() {
//            let p = predicate(productPageId, productId)
//            guard let cdProductPage = CDProductPage.listAC(predicate: p).first as? CDProductPage else {
//                result(nil); return
//            }
//            result(cdProductPage)
//        }
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            perform()
//        })
//    }
//    
//    // MARK: - Helpers
//    
//    func extractCDProductPages(_ questProductPages: [QuestProductPage]?) -> NSSet {
//        var pages = NSSet()
//        guard let questProductPages = questProductPages else { return pages }
//        for qpp in questProductPages {
//            pages = pages.adding(parseToCoreData(qpp)) as NSSet
//        }
//        return pages
//    }
//    
//    func extractQuestProductPages(_ cdProductPages: NSSet?) -> [QuestProductPage] {
//        var productPages = [QuestProductPage]()
//        guard let cdProductPages = cdProductPages else { return productPages }
//        for qp in cdProductPages {
//            productPages.append(parseFromCoreData(qp as! CDProductPage))
//        }
//        return productPages
//    }
//    
//    private func predicate(_ productPageId: String, _ productId: String) -> NSPredicate {
//        return NSPredicate(format: "id == %@ AND product.id == %@", productPageId, productId)
//    }
//}
