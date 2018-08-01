//
//  QuestPageDA.swift
//  AwesomeCore
//
//  Created by Antonio on 12/29/17.
//

//import Foundation
//
//class QuestPageDA {
//    
//    let questSectionDA = QuestSectionDA()
//    let questTaskDA = QuestTaskDA()
//    
//    // MARK: - Parser
//    
//    func parseToCoreData(_ questPage: QuestPage, result: @escaping (CDPage) -> Void) {
//        AwesomeCoreDataAccess.shared.backgroundContext.perform {
//            let cdPage = self.parseToCoreData(questPage)
//            result(cdPage)
//        }
//    }
//    
//    func parseToCoreData(_ questPage: QuestPage) -> CDPage {
//        
//        guard let pageId = questPage.id else {
//            fatalError("CDPage object can't be created without id.")
//        }
//        let p = predicate(pageId, questPage.questId ?? "")
//        let cdPage = CDPage.getObjectAC(predicate: p, createIfNil: true) as! CDPage
//        
//        cdPage.completionsCount = Int16(questPage.completionsCount)
//        cdPage.date = questPage.date
//        cdPage.about = questPage.description
//        cdPage.duration = questPage.duration ?? 0
//        cdPage.groupName = questPage.groupName
//        cdPage.id = questPage.id
//        cdPage.name = questPage.name
//        cdPage.position = Int16(questPage.position)
//        cdPage.sections = self.questSectionDA.extractCDSections(questPage.sections)
//        cdPage.tasks = self.questTaskDA.extractCDTasks(questPage.tasks)
//        cdPage.type = questPage.type
//        cdPage.isCompleted = questPage.completed ?? false
//        return cdPage
//    }
//    
//    func parseFromCoreData(_ cdPage: CDPage) -> QuestPage {
//        return QuestPage(
//            completionsCount: Int(cdPage.completionsCount),
//            date: cdPage.date ,
//            description: cdPage.about,
//            duration: cdPage.duration,
//            groupName: cdPage.groupName,
//            id: cdPage.id,
//            name: cdPage.name,
//            position: Int(cdPage.position),
//            sections: questSectionDA.extractQuestSections(cdPage.sections),
//            tasks: questTaskDA.extractQuestTasks(cdPage.tasks),
//            type: cdPage.type,
//            url: nil,
//            completed: cdPage.isCompleted,
//            questId: cdPage.quest?.id
//        )
//    }
//    
//    // MARK: - Fetch
//    
//    func loadBy(pageId: String, questId: String, result: @escaping (CDPage?) -> Void) {
//        func perform() {
//            let p = predicate(pageId, questId)
//            guard let cdPage = CDPage.listAC(predicate: p).first as? CDPage else {
//                result(nil)
//                return
//            }
//            result(cdPage)
//        }
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            perform()
//        })
//    }
//    
//    // MARK: - Save/Delete
//    
//    func save(_ page: QuestPage) {
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            _ = self.parseToCoreData(page)
//        })
//    }
//    
//    // MARK: - Helpers
//    
//    func extractCDPages(_ questPages: [QuestPage]?) -> NSSet {
//        var pages = NSSet()
//        guard let questPages = questPages else { return pages }
//        for qp in questPages {
//            pages = pages.adding(parseToCoreData(qp)) as NSSet
//        }
//        return pages
//    }
//    
//    func extractQuestPages(_ cdQuestPages: NSSet?) -> [QuestPage] {
//        var pages = [QuestPage]()
//        guard let cdQuestPages = cdQuestPages else { return pages }
//        for qp in cdQuestPages {
//            pages.append(parseFromCoreData(qp as! CDPage))
//        }
//        return pages
//    }
//    
//    private func predicate(_ pageId: String, _ questId: String) -> NSPredicate {
//        return NSPredicate(format: "id == %@ AND quest.id == %@", pageId, questId)
//    }
//    
//}
