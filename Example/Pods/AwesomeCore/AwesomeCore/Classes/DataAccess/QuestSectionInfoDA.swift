//
//  QuestSectionInfoDA.swift
//  AwesomeCore
//
//  Created by Antonio on 12/27/17.
//

//import Foundation
//
//class QuestSectionInfoDA {
//
//    // MARK: - Parser
//    
//    func parseToCoreData(_ questSectionInfo: QuestSectionInfo, completion: @escaping (_ cdSectionInfo: CDSectionInfo) -> Void) {
//        AwesomeCoreDataAccess.shared.backgroundContext.perform {
//            let cdSectionInfo = self.parserToCoreData(questSectionInfo)
//            completion(cdSectionInfo)
//        }
//    }
//    
//    func parserToCoreData(_ questSectionInfo: QuestSectionInfo) -> CDSectionInfo {
//        
//        guard let sectionInfoId = questSectionInfo.id else {
//            fatalError("CDSectionInfo object can't be created without id.")
//        }
//        let p = predicate(sectionInfoId, questSectionInfo.sectionId ?? "")
//        let cdSectionInfo = CDSectionInfo.getObjectAC(predicate: p, createIfNil: true) as! CDSectionInfo
//        
//        cdSectionInfo.body = questSectionInfo.body
//        cdSectionInfo.caption = questSectionInfo.caption
//        cdSectionInfo.downloadable = questSectionInfo.downloadable ?? false
//        cdSectionInfo.externalLink = questSectionInfo.externalLink
//        cdSectionInfo.id = questSectionInfo.id
//        cdSectionInfo.link = questSectionInfo.link
//        cdSectionInfo.mode = questSectionInfo.mode
//        cdSectionInfo.title = questSectionInfo.title
//        return cdSectionInfo
//    }
//    
//    func parseFromCoreData(_ cdSectionInfo: CDSectionInfo) -> QuestSectionInfo {
//        return QuestSectionInfo(
//            body: cdSectionInfo.body,
//            caption: cdSectionInfo.caption,
//            downloadable: cdSectionInfo.downloadable,
//            externalLink: cdSectionInfo.externalLink,
//            id: cdSectionInfo.id,
//            link: cdSectionInfo.link,
//            mode: cdSectionInfo.mode,
//            title: cdSectionInfo.title,
//            sectionId: cdSectionInfo.section?.id
//        )
//    }
//    
//    // MARK: - Fetch
//    
//    func loadBy(sectionInfoId: String, sectionId: String, completion: @escaping (CDSectionInfo?) -> Void) {
//        func perform() {
//            let p = predicate(sectionInfoId, sectionId)
//            guard let cdSectionInfo = CDSectionInfo.listAC(predicate: p).first as? CDSectionInfo else {
//                completion(nil); return
//            }
//            completion(cdSectionInfo)
//        }
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            perform()
//        })
//    }
//    
//    // MARK: - Helpers
//    
//    private func predicate(_ sectionInfoId: String, _ sectionId: String) -> NSPredicate {
//        return NSPredicate(format: "id == %@ AND section.id == %@", sectionInfoId, sectionId)
//    }
//}
