//
//  QuestDA.swift
//  AwesomeCore
//
//  Created by Antonio on 1/3/18.
//

//import Foundation
//
//class QuestDA {
//    
//    let questAuthorDA = QuestAuthorDA()
//    let questAssetDA = QuestAssetDA()
//    let questUserProgressDA = QuestUserProgressDA()
//    let questSettingsDA = QuestSettingsDA()
//    let questCategoryDA = QuestCategoryDA()
//    let questPageDA = QuestPageDA()
//    
//    // MARK: - Parser
//    
//    func parseToCoreData(_ quest: Quest, result: @escaping (CDQuest) -> Void) {
//        AwesomeCoreDataAccess.shared.performInBackground {
//            let cdQuest = self.parseToCoreData(quest)
//            result(cdQuest)
//        }
//    }
//    
//    private func parseToCoreData(_ quest: Quest) -> CDQuest {
//        
//        guard let questId = quest.id else {
//            fatalError("CDQuest object can't be created without id.")
//        }
//        let p = self.predicate(questId)
//        let cdQuest = CDQuest.getObjectAC(predicate: p, createIfNil: true) as! CDQuest
//        
//        cdQuest.id = quest.id
//        cdQuest.name = quest.name
//        cdQuest.categories = self.questCategoryDA.extractCDCategories(quest.categories)
//        cdQuest.authors = self.questAuthorDA.extractCDAuthors(quest.authors)
//        cdQuest.pages = self.questPageDA.extractCDPages(quest.pages)
//        cdQuest.courseStartedAt = quest.courseStartedAt
//        cdQuest.courseEndedAt = quest.courseEndedAt
//        cdQuest.enrollmentStartedAt = quest.enrollmentStartedAt
//        cdQuest.published = quest.published
////        cdQuest.enrollmentsCount = Int16(quest.enrollmentsCount)
//        cdQuest.url = quest.url
//        
//        if let asset = quest.coverAsset {
//            cdQuest.coverAsset = self.questAssetDA.parseToCoreData(asset, coreDataProperty: .cdQuest_coverAsset)
//        }
//        if let asset = quest.shareAsset {
//            cdQuest.shareAsset = self.questAssetDA.parseToCoreData(asset, coreDataProperty: .cdQuest_coverAsset)
//        }
//        if let cdUserProgress = quest.userProgress {
//            cdQuest.userProgress = self.questUserProgressDA.parseToCoreData(cdUserProgress, quest: quest)
//        }
//        if let settings = quest.settings {
//            cdQuest.settings = self.questSettingsDA.parseToCoreData(settings, quest: quest)
//        }
//        
//        return cdQuest
//    }
//    
//    func parseFromCoreData(_ cdQuest: CDQuest) -> Quest {
//        var coverAsset: QuestAsset? {
//            guard let asset = cdQuest.coverAsset else { return nil }
//            return questAssetDA.parseFromCoreData(asset)
//        }
//        var shareAsset: QuestAsset? {
//            guard let asset = cdQuest.shareAsset else { return nil }
//            return questAssetDA.parseFromCoreData(asset)
//        }
//        var settings: QuestSettings? {
//            guard let settings = cdQuest.settings else { return nil }
//            return questSettingsDA.parseFromCoreData(settings)
//        }
//        var userProgress: QuestUserProgress? {
//            guard let userProgress = cdQuest.userProgress else { return nil }
//            return questUserProgressDA.parseFromCoreData(userProgress)
//        }
//        return Quest(
//            authors: questAuthorDA.extractQuestAuthors(cdQuest.authors),
//            categories: questCategoryDA.extractQuestCategories(cdQuest.categories),
//            courseEndedAt: cdQuest.courseEndedAt,
//            courseStartedAt: cdQuest.courseStartedAt,
//            coverAsset: coverAsset,
//            shareAsset: shareAsset,
//            duration: 0, // There's no persistent property on CoreData model for this field
//            enrollmentStartedAt: cdQuest.enrollmentStartedAt,
//            enrollmentsCount: Int(cdQuest.enrollmentsCount),
//            id: cdQuest.id,
//            name: cdQuest.name,
//            pages: questPageDA.extractQuestPages(cdQuest.pages),
//            published: cdQuest.published,
//            publishedAt: nil,
//            url: cdQuest.url,
//            settings: settings,
//            userProgress: userProgress
//        )
//    }
//    
//    // MARK: - Fetch
//    
//    func loadBy(questId: String, result: @escaping (CDQuest?) -> Void) {
//        func perform() {
//            let p = predicate(questId)
//            guard let cdQuest = CDQuest.listAC(predicate: p).first as? CDQuest else {
//                result(nil)
//                return
//            }
//            result(cdQuest)
//        }
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            perform()
//        })
//    }
//    
//    // MARK: - Save/Delete
//    
//    func save(_ quest: Quest) {
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            _ = self.parseToCoreData(quest)
//        })
//    }
//    
//    func deleteAll() {
//        CDQuest.deleteAllUsingBackgroundContext()
//    }
//    
//    // MARK: - Helpers
//    
//    private func predicate(_ questId: String) -> NSPredicate {
//        return NSPredicate(format: "id == %@", questId)
//    }
//}

