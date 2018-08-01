//
//  QuestCategoryDA.swift
//  AwesomeCore
//
//  Created by Antonio on 1/9/18.
//

//import Foundation
//
//class QuestCategoryDA {
//    
//    // MARK: - Parser
//    
//    func parseToCoreData(_ questCategory: QuestCategory, result: @escaping (CDCategory) -> Void) {
//        AwesomeCoreDataAccess.shared.backgroundContext.perform {
//            let cdCategory = self.parseToCoreData(questCategory)
//            result(cdCategory)
//        }
//    }
//    
//    func parseToCoreData(_ questCategory: QuestCategory) -> CDCategory {
//        
//        guard let categoryId = questCategory.id else {
//            fatalError("CDCategory object can't be created without id.")
//        }
//        let p = predicate(categoryId, questCategory.questId ?? "")
//        let cdCategory = CDCategory.getObjectAC(predicate: p, createIfNil: true) as! CDCategory
//        
//        cdCategory.id = questCategory.id
//        cdCategory.name = questCategory.name
//        return cdCategory
//    }
//    
//    func parseFromCoreData(_ cdCategory: CDCategory) -> QuestCategory {
//        
//        /**
//         * As we have a relationship QuestCategory to Many Quests we have to go through
//         * both relationships looking for a combination.
//         */
//        var questId: String? {
//            guard let quests = cdCategory.quests else { return nil }
//            for cdQuest in quests.allObjects {
//                if (cdQuest as! CDQuest).categories == nil { continue }
//                for categories in (cdQuest as! CDQuest).categories!.allObjects where (categories as! CDCategory) == cdCategory {
//                    return (cdQuest as! CDQuest).id
//                }
//            }
//            return nil
//        }
//        
//        return QuestCategory(id: cdCategory.id, name: cdCategory.name, questId: questId)
//    }
//    
//    // MARK: - Fetch
//    
//    func loadBy(categoryId: String, questId: String, result: @escaping (CDCategory?) -> Void) {
//        func perform() {
//            let p = predicate(categoryId, questId)
//            guard let cdCategory = CDCategory.listAC(predicate: p).first as? CDCategory else {
//                result(nil)
//                return
//            }
//            result(cdCategory)
//        }
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            perform()
//        })
//    }
//    
//    // MARK: - Helpers
//    
//    func extractCDCategories(_ questCategories: [QuestCategory]?) -> NSSet {
//        var categories = NSSet()
//        guard let questCategories = questCategories else { return categories }
//        for qc in questCategories {
//            categories = categories.adding(parseToCoreData(qc)) as NSSet
//        }
//        return categories
//    }
//    
//    func extractQuestCategories(_ questCategories: NSSet?) -> [QuestCategory] {
//        var categories = [QuestCategory]()
//        guard let questCategories = questCategories else { return categories }
//        for qc in questCategories {
//            categories.append(parseFromCoreData(qc as! CDCategory))
//        }
//        return categories
//    }
//    
//    private func predicate(_ categoryId: String, _ questId: String) -> NSPredicate {
//        return NSPredicate(format: "id == %@ AND quests.id CONTAINS[cd] %@", categoryId, questId)
//    }
//    
//}
