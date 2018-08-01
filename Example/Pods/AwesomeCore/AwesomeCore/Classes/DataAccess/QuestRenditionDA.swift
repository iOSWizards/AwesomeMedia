//
//  QuestRenditionDA.swift
//  AwesomeCore
//
//  Created by Antonio on 12/19/17.
//

//import Foundation
//
//class QuestRenditionDA {
//    
//    // MARK: - Parser
//    
//    public func parseToCoreData(_ questRendition: QuestRendition, completion: @escaping (CDAssetRendition) -> Void) {
//        AwesomeCoreDataAccess.shared.backgroundContext.perform {
//            let cdRendition = self.parseToCoreData(questRendition)
//            completion(cdRendition)
//        }
//    }
//    
//    private func parseToCoreData(_ questRendition: QuestRendition) -> CDAssetRendition {
//        
//        guard let renditionId = questRendition.id else {
//            fatalError("CDAssetRendition object can't be created without id.")
//        }
//        let p = predicate(renditionId, questRendition.assetId ?? "")
//        let cdRendition = CDAssetRendition.getObjectAC(predicate: p, createIfNil: true) as! CDAssetRendition
//        
//        cdRendition.contentType = questRendition.contentType
//        cdRendition.duration = questRendition.duration ?? 0
//        cdRendition.edgeUrl = questRendition.edgeUrl
//        cdRendition.filesize = Int64(questRendition.filesize ?? 0)
//        cdRendition.id = questRendition.id
//        cdRendition.name = questRendition.name
//        cdRendition.overmindId = questRendition.overmindId
//        cdRendition.secure = questRendition.secure ?? false
//        cdRendition.status = questRendition.status
//        cdRendition.thumbnailUrl = questRendition.thumbnailUrl
//        cdRendition.url = questRendition.url
//        return cdRendition
//    }
//    
//    func parseFromCoreData(_ cdAssetRendition: CDAssetRendition) -> QuestRendition {
//        return QuestRendition(
//            contentType: cdAssetRendition.contentType,
//            duration: cdAssetRendition.duration,
//            edgeUrl: cdAssetRendition.edgeUrl,
//            filesize: Int(cdAssetRendition.filesize),
//            id: cdAssetRendition.id,
//            name: cdAssetRendition.name,
//            overmindId: cdAssetRendition.overmindId,
//            secure: cdAssetRendition.secure,
//            status: cdAssetRendition.status,
//            thumbnailUrl: cdAssetRendition.thumbnailUrl,
//            url: cdAssetRendition.url,
//            assetId: cdAssetRendition.asset?.id
//        )
//    }
//    
//    // MARK: - Fetch
//    
//    func loadBy(renditionId: String, assetId: String, completion: @escaping (CDAssetRendition?) -> Void) {
//        func perform() {
//            let p = predicate(renditionId, assetId)
//            guard let cdMarker = CDAssetRendition.listAC(predicate: p).first as? CDAssetRendition else {
//                completion(nil)
//                return
//            }
//            completion(cdMarker)
//        }
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            perform()
//        })
//    }
//    
//    // MARK: - Helpers
//    
//    func extractQuestRenditions(_ questRenditions: [QuestRendition]?) -> NSSet {
//        var renditions = NSSet()
//        guard let questRenditions = questRenditions else {
//            return renditions
//        }
//        for qr in questRenditions {
//            renditions = renditions.adding(parseToCoreData(qr)) as NSSet
//        }
//        return renditions
//    }
//    
//    func extractCDAssetRendition(_ questRenditions: NSSet?) -> [QuestRendition]? {
//        guard let questRenditions = questRenditions else {
//            return nil
//        }
//        var renditions = [QuestRendition]()
//        for qr in questRenditions {
//            renditions.append(parseFromCoreData(qr as! CDAssetRendition))
//        }
//        return renditions
//    }
//    
//    private func predicate(_ markerId: String, _ assetId: String) -> NSPredicate {
//        return NSPredicate(format: "id == %@ AND asset.id == %@", markerId, assetId)
//    }
//}
