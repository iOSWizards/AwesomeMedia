//
//  QuestAssetDA.swift
//  AwesomeCore
//
//  Created by Antonio on 12/18/17.
//

//import Foundation
//
///// This enum represents the QuestAsset properties associtiation for CoreData Models,
///// for instance, *CDQuest has a property coverAsset, it is represented here as:*
///// **cdQuest_coverAsset**. So in order to parse the Quest.coverAsset to CDQuest.CDAsset
///// the **cdQuest_coverAsset** must be used when calling the parseToCoreData method.
/////
///// - cdSection_primaryAsset: CDSection.primaryAsset
///// - cdSection_coverAsset: CDSection.coverAsset
///// - cdAuthorQuests_avatarAsset: CDAuthorQuests.avatarAsset
///// - cdQuest_coverAsset: CDQuest.coverAsset
///// - cdQuest_shareAsset: CDQuest.shareAsset
///// - cdProduct_imageAsset: CDProduct.imageAsset
///// - cdProduct_featuredAsset: CDProduct.featuredAsset
//enum AssetPropertyCoreData {
//    case cdSection_primaryAsset
//    case cdSection_coverAsset
//    case cdAuthorQuests_avatarAsset
//    case cdQuest_coverAsset
//    case cdQuest_shareAsset
//    case cdProduct_imageAsset
//    case cdProduct_featuredAsset
//}
//
//class QuestAssetDA {
//    
//    let questMarkerDA = QuestMarkerDA()
//    let questRenditionDA = QuestRenditionDA()
//    
//    // MARK: - Parser
//    
//    func parseToCoreData(
//        _ questAsset: QuestAsset,
//        coreDataProperty: AssetPropertyCoreData,
//        completion: @escaping (CDAsset) -> Void) {
//        AwesomeCoreDataAccess.shared.performInBackground {
//            let cdAsset = self.parseToCoreData(questAsset, coreDataProperty: coreDataProperty)
//            completion(cdAsset)
//        }
//    }
//    
//    // MARK: Sync
//    
//    func parseToCoreData(_ questAsset: QuestAsset, coreDataProperty: AssetPropertyCoreData) -> CDAsset {
//        let cdAsset = buildCDAsset(type: coreDataProperty, questAsset: questAsset)
//        return configCDAsset(cdAsset, with: questAsset)
//    }
//    
//    func parseFromCoreData(_ cdAsset: CDAsset) -> QuestAsset {
//        return QuestAsset(
//            contentType: cdAsset.contentType,
//            duration: cdAsset.duration,
//            edgeUrl: cdAsset.edgeUrl,
//            filesize: Int(cdAsset.filesize),
//            id: cdAsset.id,
//            markers: questMarkerDA.extractQuestMarkers(cdAsset.markers),
//            name: cdAsset.name,
//            overmindId: cdAsset.overmindId,
//            renditions: questRenditionDA.extractCDAssetRendition(cdAsset.renditions),
//            secure: cdAsset.secure,
//            status: cdAsset.status,
//            thumbnailUrl: cdAsset.thumbnailUrl,
//            url: cdAsset.url,
//            sectionPrimaryId: cdAsset.sectionPrimary?.id,
//            sectionCoverId: cdAsset.sectionCover?.id,
//            authorAvatarId: cdAsset.author?.id,
//            questCoverId: cdAsset.questCover?.id,
//            questShareId: cdAsset.questShare?.id,
//            productId: cdAsset.product?.id,
//            productFeaturedAssetId: cdAsset.productFeaturedAsset?.id
//        )
//    }
//    
//    // MARK: - Fetch
//    
//    func loadCoverAssetBy(assetId: String, sectionId: String, completion: @escaping (CDAsset?) -> Void) {
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            self.searchWith(type: .cdSection_coverAsset, assetId: assetId, sectionId: sectionId, result: completion)
//        })
//    }
//    
//    func loadPrimaryAssetBy(assetId: String, sectionId: String, completion: @escaping (CDAsset?) -> Void) {
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            self.searchWith(type: .cdSection_primaryAsset, assetId: assetId, sectionId: sectionId, result: completion)
//        })
//    }    
//    
//    // MARK: - Helpers
//    
//    private func configCDAsset(_ cdAsset: CDAsset, with questAsset: QuestAsset) -> CDAsset {
//        cdAsset.contentType = questAsset.contentType
//        cdAsset.duration = questAsset.duration ?? 0
//        cdAsset.edgeUrl = questAsset.edgeUrl
//        cdAsset.filesize = Int64(questAsset.filesize ?? 0)
//        cdAsset.id = questAsset.id
//        cdAsset.markers = self.questMarkerDA.extractCDMarkers(questAsset.markers)
//        cdAsset.name = questAsset.name
//        cdAsset.overmindId = questAsset.overmindId
//        cdAsset.renditions = self.questRenditionDA.extractQuestRenditions(questAsset.renditions)
//        cdAsset.secure = questAsset.secure ?? false
//        cdAsset.status = questAsset.status
//        cdAsset.thumbnailUrl = questAsset.thumbnailUrl
//        cdAsset.url = questAsset.url
//        return cdAsset
//    }
//    
//    /// Helper method used to either load a CDAsset or create a new one.
//    /// - Important: _This method must be called from within a BackgroundContext._
//    ///
//    /// - Parameters:
//    ///   - type: SearchType used to identify the search
//    ///   - assetId: the CDAsset ID
//    ///   - sectionId: the CDSection ID
//    private func buildCDAsset(type: AssetPropertyCoreData, questAsset: QuestAsset) -> CDAsset {
//        
//        guard let assetId = questAsset.id else {
//            fatalError("CDAsset object can't be created without id.")
//        }
//        
//        let parentId: String!
//        switch type {
//        case .cdSection_primaryAsset:
//            parentId = questAsset.sectionPrimaryId ?? ""
//        case .cdSection_coverAsset:
//            parentId = questAsset.sectionCoverId ?? ""
//        case .cdAuthorQuests_avatarAsset:
//            parentId = questAsset.authorAvatarId ?? ""
//        case .cdQuest_coverAsset:
//            parentId = questAsset.questCoverId ?? ""
//        case .cdQuest_shareAsset:
//            parentId = questAsset.questShareId ?? ""
//        case .cdProduct_imageAsset:
//            parentId = questAsset.productId ?? ""
//        case .cdProduct_featuredAsset:
//            parentId = questAsset.productFeaturedAssetId ?? ""
//        }
//        
//        let p = predicateFor(type: type, assetId: assetId, parentId: parentId)
//        return CDAsset.getObjectAC(predicate: p, createIfNil: true) as! CDAsset
//    }
//    
//    /// Search helper method.
//    /// - Important: _This method must be called from within a BackgroundContext._
//    ///
//    /// - Parameters:
//    ///   - type: SearchType used to identify the search
//    ///   - assetId: the CDAsset ID
//    ///   - sectionId: the CDSection ID
//    ///   - result: completion handler used to receive the CDAsset fetched.
//    private func searchWith(type: AssetPropertyCoreData, assetId: String, sectionId: String, result: @escaping (CDAsset?) -> Void) {
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            let p = self.predicateFor(type: type, assetId: assetId, parentId: sectionId)
//            guard let cdAsset = CDAsset.listAC(predicate: p).first as? CDAsset else { result(nil); return }
//            result(cdAsset)
//        })
//    }
//    
//    private func predicateFor(type: AssetPropertyCoreData, assetId: String, parentId: String) -> NSPredicate {
//        let p: NSPredicate!
//        switch type {
//        case .cdSection_primaryAsset:
//            p = NSPredicate(format: "id == %@ AND sectionPrimary.id == %@", assetId, parentId)
//        case .cdSection_coverAsset:
//            p = NSPredicate(format: "id == %@ AND sectionCover.id == %@", assetId, parentId)
//        case.cdAuthorQuests_avatarAsset:
//            p = NSPredicate(format: "id == %@ AND author.id == %@", assetId, parentId)
//        case.cdQuest_coverAsset:
//            p = NSPredicate(format: "id == %@ AND questCover.id == %@", assetId, parentId)
//        case.cdQuest_shareAsset:
//            p = NSPredicate(format: "id == %@ AND questShare.id == %@", assetId, parentId)
//        case.cdProduct_imageAsset:
//            p = NSPredicate(format: "id == %@ AND product.id == %@", assetId, parentId)
//        case.cdProduct_featuredAsset:
//            p = NSPredicate(format: "id == %@ AND productFeaturedAsset.id == %@", assetId, parentId)
//        }
//        return p
//    }
//}
