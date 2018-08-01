//
//  QuestAuthorDA.swift
//  AwesomeCore
//
//  Created by Antonio on 1/2/18.
//

//import Foundation
//
//class QuestAuthorDA {
//    
//    let questAssetDA = QuestAssetDA()
//    
//    // MARK: - Parser
//    
//    func parseToCoreData(_ questAuthor: QuestAuthor, result: @escaping (CDAuthorQuests) -> Void) {
//        AwesomeCoreDataAccess.shared.backgroundContext.perform {
//            let cdAuthorQuest = self.parseToCoreData(questAuthor)
//            result(cdAuthorQuest)
//        }
//    }
//    
//    private func parseToCoreData(_ questAuthor: QuestAuthor) -> CDAuthorQuests {
//        
//        guard let authorId = questAuthor.id else {
//            fatalError("CDAuthorQuests object can't be created without id.")
//        }
//        let p = predicate(authorId, questAuthor.questId ?? "")
//        let cdAuthorQuest = CDAuthorQuests.getObjectAC(predicate: p, createIfNil: true) as! CDAuthorQuests
//        
//        cdAuthorQuest.id = questAuthor.id
//        cdAuthorQuest.name = questAuthor.name
//        cdAuthorQuest.about = questAuthor.description
//        
//        if let asset = questAuthor.avatarAsset {
//            cdAuthorQuest.avatarAsset = questAssetDA.parseToCoreData(asset, coreDataProperty: .cdAuthorQuests_avatarAsset)
//        }
//        
//        return cdAuthorQuest
//    }
//    
//    func parseFromCoreData(_ cdAuthor: CDAuthorQuests) -> QuestAuthor {
//        
//        var avatarAsset: QuestAsset? {
//            guard let asset = cdAuthor.avatarAsset else { return nil }
//            return questAssetDA.parseFromCoreData(asset)
//        }
//        
//        /**
//         * As we have a relationship Author to Many Quests we have to go through
//         * both relationships looking for a combination.
//         */
//        var questId: String? {
//            guard let quests = cdAuthor.quests else { return nil }
//            for cdQuest in quests.allObjects {
//                if (cdQuest as! CDQuest).authors == nil { continue }
//                for author in (cdQuest as! CDQuest).authors!.allObjects where (author as! CDAuthorQuests) == cdAuthor {
//                    return (cdQuest as! CDQuest).id
//                }
//            }
//            return nil
//        }
//        
//        return QuestAuthor(
//            avatarAsset: avatarAsset,
//            description: cdAuthor.about,
//            id: cdAuthor.id,
//            name: cdAuthor.name,
//            slug: nil,
//            questId: questId
//        )
//    }
//    
//    // MARK: - Fetch
//    
//    func loadBy(authorId: String, questId: String, result: @escaping (CDAuthorQuests?) -> Void) {
//        func perform() {
//            let p = predicate(authorId, questId)
//            guard let cdAuthorQuests = CDAuthorQuests.listAC(predicate: p).first as? CDAuthorQuests else {
//                result(nil)
//                return
//            }
//            result(cdAuthorQuests)
//        }
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            perform()
//        })
//    }
//    
//    // MARK: - Helpers
//    
//    /// Extract the given QuestAuthor array as a NSSet (CoreData) objects.
//    /// - Important: _This method must be called from within a BackgroundContext._
//    ///
//    /// - Parameter questAuthors: Array of QuestAuthor
//    /// - Returns: a NSSet of CoreData CDAuthorQuests or an empty NSSet.
//    func extractCDAuthors(_ questAuthors: [QuestAuthor]?) -> NSSet {
//        var authors = NSSet()
//        guard let questAuthors = questAuthors else { return authors }
//        for qa in questAuthors {
//            authors = authors.adding(parseToCoreData(qa)) as NSSet
//        }
//        return authors
//    }
//    
//    func extractQuestAuthors(_ questAuthors: NSSet?) -> [QuestAuthor] {
//        var authors = [QuestAuthor]()
//        guard let questAuthors = questAuthors else { return authors }
//        for qa in questAuthors {
//            authors.append(parseFromCoreData(qa as! CDAuthorQuests))
//        }
//        return authors
//    }
//    
//    private func predicate(_ authorId: String, _ questId: String) -> NSPredicate {
//        return NSPredicate(format: "id == %@ AND quests.id CONTAINS[cd] %@", authorId, questId)
//    }
//
//}
