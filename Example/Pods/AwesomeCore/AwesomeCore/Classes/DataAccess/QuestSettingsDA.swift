//
//  QuestSettingsDA.swift
//  AwesomeCore
//
//  Created by Antonio on 1/8/18.
//

//import Foundation
//
//class QuestSettingsDA {
//    
//    // MARK: - Parser
//    
//    func parseToCoreData(_ questSettings: QuestSettings, quest: Quest, result: @escaping (CDQuestSettings) -> Void) {
//        AwesomeCoreDataAccess.shared.backgroundContext.perform {
//            let cdQuestSettings = self.parseToCoreData(questSettings, quest: quest)
//            result(cdQuestSettings)
//        }
//    }
//    
//    func parseFromCoreData(_ cdQuestSettings: CDQuestSettings) -> QuestSettings {
//        return QuestSettings(
//            awcProductId: cdQuestSettings.awcProductId,
//            facebookGroupImageUrl: cdQuestSettings.facebookGroupImageUrl,
//            facebookGroupPassPhrase: cdQuestSettings.facebookGroupPassPhrase,
//            facebookGroupUrl: cdQuestSettings.facebookGroupUrl,
//            facebookGroupId: cdQuestSettings.facebookGroupId,
//            perpetual: cdQuestSettings.perpetual,
//            salesUrl: cdQuestSettings.salesUrl,
//            shareImageUrl: cdQuestSettings.shareImageUrl,
//            studentsCount: Int(cdQuestSettings.studentsCount),
//            questId: cdQuestSettings.quest?.id
//        )
//    }
//    
//    func parseToCoreData(_ questSettings: QuestSettings, quest: Quest) -> CDQuestSettings {
//        
//        guard let questId = quest.id else {
//            fatalError("CDQuestSettings object can't be created without id.")
//        }
//        let p = predicate(questId)
//        let cdQuestSettings = CDQuestSettings.getObjectAC(predicate: p, createIfNil: true) as! CDQuestSettings
//        
//        cdQuestSettings.awcProductId = questSettings.awcProductId
//        cdQuestSettings.facebookGroupId = questSettings.facebookGroupId
//        cdQuestSettings.facebookGroupImageUrl = questSettings.facebookGroupImageUrl
//        cdQuestSettings.facebookGroupPassPhrase = questSettings.facebookGroupPassPhrase
//        cdQuestSettings.facebookGroupUrl = questSettings.facebookGroupUrl
//        cdQuestSettings.perpetual = questSettings.perpetual
//        cdQuestSettings.salesUrl = questSettings.salesUrl
//        cdQuestSettings.shareImageUrl = questSettings.shareImageUrl
//        cdQuestSettings.studentsCount = Int16(questSettings.studentsCount ?? 0)
//        
//        // as we have a one to one relationship we can use a Quest id as a QuestSettings id
//        cdQuestSettings.id = questSettings.questId
//        
//        return cdQuestSettings
//    }
//    
//    // MARK: - Fetch
//    
//    func loadBy(settingsId: String, result: @escaping (CDQuestSettings?) -> Void) {
//        func perform() {
//            let p = predicate(settingsId)
//            guard let cdSettings = CDQuestSettings.listAC(predicate: p).first as? CDQuestSettings else {
//                result(nil)
//                return
//            }
//            result(cdSettings)
//        }
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            perform()
//        })
//    }
//    
//    // MARK: - Helpers
//    
//    private func predicate(_ settingsId: String) -> NSPredicate {
//        return NSPredicate(format: "id == %@", settingsId)
//    }
//}

