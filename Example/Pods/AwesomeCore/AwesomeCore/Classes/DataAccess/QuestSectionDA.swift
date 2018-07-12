//
//  QuestSectionDA.swift
//  AwesomeCore
//
//  Created by Antonio on 12/26/17.
//

//import Foundation
//
//class QuestSectionDA {
//    
//    let questAssetDA = QuestAssetDA()
//    let questSectionInfoDA = QuestSectionInfoDA()
//    
//    // MARK: - Parser
//    
//    func parseToCoreData(_ questSection: QuestSection, result: @escaping (CDSection) -> Void) {
//        AwesomeCoreDataAccess.shared.backgroundContext.perform {
//            let cdSection = self.parseToCoreData(questSection)
//            result(cdSection)
//        }
//    }
//    
//    private func parseToCoreData(_ questSection: QuestSection) -> CDSection {
//        
//        guard let sectionId = questSection.id else {
//            fatalError("CDSection object can't be created without id.")
//        }
//        let p = predicate(sectionId, questSection.pageId ?? "")
//        let cdSection = CDSection.getObjectAC(predicate: p, createIfNil: true) as! CDSection
//        
//        cdSection.duration = questSection.duration
//        cdSection.id = questSection.id
//        cdSection.position = Int16(questSection.position)
//        cdSection.type = questSection.type
//        
//        if let asset = questSection.coverAsset {
//            cdSection.coverAsset = self.questAssetDA.parseToCoreData(asset, coreDataProperty: .cdSection_coverAsset)
//        }
//        if let info = questSection.info {
//            cdSection.info = self.questSectionInfoDA.parserToCoreData(info)
//        }
//        if let asset = questSection.primaryAsset {
//            cdSection.primaryAsset = self.questAssetDA.parseToCoreData(asset, coreDataProperty: .cdSection_primaryAsset)
//        }
//        return cdSection
//    }
//    
//    func parseFromCoreData(_ cdSection: CDSection) -> QuestSection {
//        
//        var coverAsset: QuestAsset? {
//            guard let coverAsset = cdSection.coverAsset else { return nil }
//            return questAssetDA.parseFromCoreData(coverAsset)
//        }
//        var info: QuestSectionInfo? {
//            guard let info = cdSection.info else { return nil }
//            return questSectionInfoDA.parseFromCoreData(info)
//        }
//        var primaryAsset: QuestAsset? {
//            guard let primaryAsset = cdSection.primaryAsset else { return nil }
//            return questAssetDA.parseFromCoreData(primaryAsset)
//        }
//        
//        return QuestSection(
//            coverAsset: coverAsset,
//            duration: cdSection.duration,
//            id: cdSection.id,
//            info: info,
//            position: Int(cdSection.position),
//            primaryAsset: primaryAsset,
//            type: cdSection.type,
//            pageId: cdSection.content?.id,
//            productPageId: cdSection.productPage?.id
//        )
//    }
//    
//    // MARK: - Fetch
//    
//    func loadBy(sectionId: String, pageId: String, result: @escaping (CDSection?) -> Void) {
//        func perform() {
//            let p = predicate(sectionId, pageId)
//            guard let cdSection = CDSection.listAC(predicate: p).first as? CDSection else {
//                result(nil)
//                return
//            }
//            result(cdSection)
//        }
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            perform()
//        })
//    }
//    
//    // MARK: - Helpers
//    
//    func extractCDSections(_ questSections: [QuestSection]?) -> NSSet {
//        var sections = NSSet()
//        guard let questSections = questSections else { return sections }
//        for qs in questSections {
//            sections = sections.adding(parseToCoreData(qs)) as NSSet
//        }
//        return sections
//    }
//    
//    func extractQuestSections(_ cdSections: NSSet?) -> [QuestSection]? {
//        guard let cdSections = cdSections else { return nil }
//        var sections = [QuestSection]()
//        for qs in cdSections {
//            sections.append(parseFromCoreData(qs as! CDSection))
//        }
//        return sections
//    }
//    
//    private func predicate(_ sectionId: String, _ pageId: String) -> NSPredicate {
//        return NSPredicate(format: "id == %@ AND content.id == %@", sectionId, pageId)
//    }
//}

