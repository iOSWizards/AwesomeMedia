//
//  QuestUserProgressDA.swift
//  AwesomeCore
//
//  Created by Antonio on 1/4/18.
//

//import Foundation
//
//class QuestUserProgressDA {
//    
//    // MARK: - Parser
//    
//    func parseToCoreData(_ questUserProgress: QuestUserProgress, quest: Quest, result: @escaping (CDUserProgress) -> Void) {
//        AwesomeCoreDataAccess.shared.backgroundContext.perform {
//            let cdUserProgress = self.parseToCoreData(questUserProgress, quest: quest)
//            result(cdUserProgress)
//        }
//    }
//    
//    func parseToCoreData(_ questUserProgress: QuestUserProgress, quest: Quest) -> CDUserProgress {
//        
//        guard let questId = quest.id else {
//            fatalError("CDUserProgress object can't be created without id.")
//        }
//        let p = predicate(questId, questUserProgress.questId ?? "")
//        let cdUserProgress = CDUserProgress.getObjectAC(predicate: p, createIfNil: true) as! CDUserProgress
//        
//        cdUserProgress.currentDayId = questUserProgress.currentDayId
//        cdUserProgress.daysCompleted = questUserProgress.daysCompleted.map(String.init).joined(separator: ", ")
//        cdUserProgress.introsCompleted = questUserProgress.introsCompleted.map(String.init).joined(separator: ", ")
//        cdUserProgress.started = questUserProgress.started
//        cdUserProgress.startedAt = questUserProgress.startedAt
//        cdUserProgress.ended = questUserProgress.ended
//        cdUserProgress.endedAt = questUserProgress.endedAt
//        cdUserProgress.completed = questUserProgress.completed
//        cdUserProgress.completedAt = questUserProgress.completedAt
//        cdUserProgress.totalDays = Int16(questUserProgress.totalDays)
//        cdUserProgress.totalDaysCompleted = Int16(questUserProgress.totalDaysCompleted)
//        cdUserProgress.totalIntros = Int16(questUserProgress.totalIntros)
//        cdUserProgress.totalIntrosCompleted = Int16(questUserProgress.totalIntrosCompleted)
//        
//        // as we have a one to one relationship we can use a Quest id as a QuestUserProgress id
//        cdUserProgress.id = questId
//        
//        return cdUserProgress
//    }
//    
//    func parseFromCoreData(_ cdUserProgress: CDUserProgress) -> QuestUserProgress {
//        
//        var daysCompleted: [Int] {
//            guard let days = cdUserProgress.daysCompleted else { return [] }
//            return days.components(separatedBy: ", ").map({(value) in
//                if let intValue = Int(value) {
//                    return intValue
//                }
//                return 0
//            })
//        }
//        var introsCompleted: [Int] {
//            guard let intros = cdUserProgress.introsCompleted else { return [] }
//            return intros.components(separatedBy: ", ").map({(value) in
//                if let intValue = Int(value) {
//                    return intValue
//                }
//                return 0
//            })
//        }
//        
//        /**
//         * we agreed on not storing the CurrentDay object instead we're storing
//         * only its id. (currentDayId)
//         */
//        return QuestUserProgress(
//            id: cdUserProgress.id,
//            currentDay: nil,
//            currentDayId: cdUserProgress.currentDayId,
//            daysCompleted: daysCompleted,
//            ended: false,
//            endedAt: nil,
//            completed: false,
//            completedAt: nil,
//            enrolledAt: nil,
//            enrollmentStartedAt: nil,
//            introsCompleted: introsCompleted,
//            started: cdUserProgress.started,
//            startedAt: nil,
//            totalDays: Int(cdUserProgress.totalDays),
//            totalDaysCompleted: Int(cdUserProgress.totalDaysCompleted),
//            totalIntros: Int(cdUserProgress.totalIntros),
//            totalIntrosCompleted: Int(cdUserProgress.totalIntrosCompleted),
//            questId: cdUserProgress.quest?.id
//        )
//    }
//    
//    // MARK: - Fetch
//    
//    func loadBy(userProgressId: String, questId: String, result: @escaping (CDUserProgress?) -> Void) {
//        func perform() {
//            let p = predicate(userProgressId, questId)
//            guard let cdUserProgress = CDUserProgress.listAC(predicate: p).first as? CDUserProgress else {
//                result(nil)
//                return
//            }
//            result(cdUserProgress)
//        }
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            perform()
//        })
//    }
//    
//    // MARK: - Helpers
//    
//    private func predicate(_ userProgressId: String, _ questId: String) -> NSPredicate {
//        return NSPredicate(format: "id == %@ AND quest.id == %@", userProgressId, questId)
//    }
//    
//}

