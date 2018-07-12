//
//  QuestMarkerDA.swift
//  AwesomeCore
//
//  Created by Antonio on 12/15/17.
//

//import Foundation
//
//class QuestMarkerDA {
//
//    // MARK: - Parser
//
//    func parseToCoreData(_ marker: QuestMarker, result: @escaping (CDMarker) -> Void) {
//        AwesomeCoreDataAccess.shared.backgroundContext.perform {
//            let cdMarker = self.parseToCoreData(marker)
//            result(cdMarker)
//        }
//    }
//
//    private func parseToCoreData(_ marker: QuestMarker) -> CDMarker {
//
//        guard let markerId = marker.id else {
//            fatalError("CDMarker object can't be created without id.")
//        }
//        let p = predicate(markerId, marker.assetId ?? "")
//        let cdMarker = CDMarker.getObjectAC(predicate: p, createIfNil: true) as! CDMarker
//
//        cdMarker.id = marker.id
//        cdMarker.name = marker.name
//        cdMarker.status = marker.status
//        cdMarker.time = marker.time
//        return cdMarker
//    }
//
//    func parseFromCoreData(_ cdMarker: CDMarker) -> QuestMarker {
//        return QuestMarker(
//            id: cdMarker.id,
//            name: cdMarker.name,
//            status: cdMarker.status,
//            time: cdMarker.time,
//            assetId: cdMarker.asset?.id
//        )
//    }
//
//    // MARK: - Fetch
//
//    func loadBy(markerId: String, assetId: String, result: @escaping (CDMarker?) -> Void) {
//        func perform() {
//            let p = predicate(markerId, assetId)
//            guard let cdMarker = CDMarker.listAC(predicate: p).first as? CDMarker else {
//                result(nil)
//                return
//            }
//            result(cdMarker)
//        }
//        AwesomeCoreDataAccess.shared.performBackgroundBatchOperation({ (workerContext) in
//            perform()
//        })
//    }
//
//    // MARK: - Helpers
//
//    /// Extract the given QuestMarker array as a NSSet (CoreData) objects.
//    /// - Important: _This method must be called from within a BackgroundContext._
//    ///
//    /// - Parameter questMarkers: Array of QuestMarkers
//    /// - Returns: a NSSet of CoreData CDMarkers or an empty NSSet.
//    func extractCDMarkers(_ questMarkers: [QuestMarker]?) -> NSSet {
//        var markers = NSSet()
//        guard let questMarkers = questMarkers else { return markers }
//        for qm in questMarkers {
//            markers = markers.adding(parseToCoreData(qm)) as NSSet
//        }
//        return markers
//    }
//
//    func extractQuestMarkers(_ questMarkers: NSSet?) -> [QuestMarker]? {
//        guard let questMarkers = questMarkers else { return nil }
//        var markers = [QuestMarker]()
//        for qm in questMarkers {
//            markers.append(parseFromCoreData(qm as! CDMarker))
//        }
//        return markers
//    }
//
//    private func predicate(_ markerId: String, _ assetId: String) -> NSPredicate {
//        return NSPredicate(format: "id == %@ AND asset.id == %@", markerId, assetId)
//    }
//
//}
