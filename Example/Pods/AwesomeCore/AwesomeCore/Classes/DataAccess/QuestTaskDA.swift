//
//  QuestTaskDA.swift
//  AwesomeCore
//
//  Created by Antonio on 12/29/17.
//

//import Foundation
//
//class QuestTaskDA {
//    
//    // MARK: - Parser
//    
//    func parseToCoreData(_ questTask: QuestTask, result: @escaping (CDTask) -> Void) {
//        AwesomeCoreDataAccess.shared.backgroundContext.perform {
//            let cdTask = self.parseToCoreData(questTask)
//            result(cdTask)
//        }
//    }
//    
//    private func parseToCoreData(_ questTask: QuestTask) -> CDTask {
//        
//        guard let taskId = questTask.id else {
//            fatalError("QuestTask object can't be created without id.")
//        }
//        let p = predicate(taskId, questTask.pageId ?? "")
//        let cdTask = CDTask.getObjectAC(predicate: p, createIfNil: true) as! CDTask
//        
//        cdTask.completed = questTask.completed
//        cdTask.completionDetails = questTask.completionDetails
//        cdTask.about = questTask.description
//        cdTask.id = questTask.id
//        cdTask.imageUrl = questTask.imageUrl
//        cdTask.name = questTask.name
//        cdTask.position = Int16(questTask.position)
//        cdTask.required = questTask.required
//        cdTask.type = questTask.type
//        return cdTask
//    }
//    
//    func parseFromCoreData(_ cdTask: CDTask) -> QuestTask {
//        return QuestTask(
//            completed: cdTask.completed,
//            completionDetails: cdTask.completionDetails,
//            description: cdTask.about,
//            id: cdTask.id,
//            imageUrl: cdTask.imageUrl,
//            name: cdTask.name,
//            position: Int(cdTask.position),
//            required: cdTask.required,
//            type: cdTask.type,
//            pageId: cdTask.page?.id
//        )
//    }
//    
//    // MARK: - Fetch
//    
//    func loadBy(taskId: String, pageId: String, result: @escaping (CDTask?) -> Void) {
//        func perform() {
//            let p = predicate(taskId, pageId)
//            guard let cdTask = CDTask.listAC(predicate: p).first as? CDTask else {
//                result(nil)
//                return
//            }
//            result(cdTask)
//        }
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            perform()
//        })
//    }
//    
//    /// Extract the given QuestTask array as a NSSet (CoreData) objects.
//    /// - Important: _This method must be called from within a BackgroundContext._
//    ///
//    /// - Parameter questTasks: Array of QuestTask
//    /// - Returns: a NSSet of CoreData CDTask or an empty NSSet.
//    func extractCDTasks(_ questTasks: [QuestTask]?) -> NSSet {
//        var tasks = NSSet()
//        guard let questTasks = questTasks else { return tasks }
//        for qt in questTasks {
//            tasks = tasks.adding(parseToCoreData(qt)) as NSSet
//        }
//        return tasks
//    }
//    
//    func extractQuestTasks(_ cdTasks: NSSet?) -> [QuestTask]? {
//        guard let cdTasks = cdTasks else { return nil }
//        var tasks = [QuestTask]()
//        for qt in cdTasks {
//            tasks.append(parseFromCoreData(qt as! CDTask))
//        }
//        return tasks
//    }
//    
//    // MARK: - Helpers
//    
//    private func predicate(_ taskId: String, _ pageId: String) -> NSPredicate {
//        return NSPredicate(format: "id == %@ AND page.id == %@", taskId, pageId)
//    }
//    
//}
