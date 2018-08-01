//
//  SectionMarkerDA.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 19/07/17.
//

//import Foundation
//
//class SectionMarkerDA {
//    
//    /// Parses a Marker (Domain Object) to our Core Data object.
//    ///
//    /// - Parameter marker: cdMarker: a Marker object.
//    /// - Returns: a CDSectionMarker object containing all data present on the Marker object.
//    public func parseToCoreData(_ marker: Marker, cdSectionMarker: CDSectionMarker? = nil) -> CDSectionMarker {
//        let cdMarker = cdSectionMarker ?? CDSectionMarker.newInstanceAC() as! CDSectionMarker
//        cdMarker.courseChapterSectionMarkerId = NSNumber(value: marker.courseChapterSectionMarkerId)
//        cdMarker.time = NSNumber(value: marker.time)
//        cdMarker.title = marker.title
//        return cdMarker
//    }
//    
//    public func parseToCoreData(_ marker: Marker, cdSectionMarker: CDSectionMarker? = nil, completion: @escaping (CDSectionMarker?) -> Void) {
//        AwesomeCoreDataAccess.shared.backgroundContext.perform {
//            let cdMarker = cdSectionMarker ?? CDSectionMarker.newInstanceAC() as! CDSectionMarker
//            cdMarker.courseChapterSectionMarkerId = NSNumber(value: marker.courseChapterSectionMarkerId)
//            cdMarker.time = NSNumber(value: marker.time)
//            cdMarker.title = marker.title
//            completion(cdMarker)
//        }
//    }
//    
//    /// Parses a CDSectionMarker (CoreData Object) to our domain model Marker.
//    ///
//    /// - Parameter cdMarker: a CDSectionMarker object.
//    /// - Returns: a Marker object containing all data present on the CDSectionMarker.
//    public func parseFromCoreData(_ cdMarker: CDSectionMarker) -> Marker {
//        
//        return Marker(
//            courseChapterSectionMarkerId: Int(truncating: cdMarker.courseChapterSectionMarkerId ?? -1),
//            title: cdMarker.title ?? "",
//            time: Int(truncating: cdMarker.time ?? -1)
//        )
//    }
//    
//    func extractCDSectionMarkers(_ sectionMarkers: [Marker]) -> NSSet {
//        var sectionMarkersSet = NSSet()
//        for marker in sectionMarkers {
//            sectionMarkersSet = sectionMarkersSet.adding(parseToCoreData(marker)) as NSSet
//        }
//        return sectionMarkersSet
//    }
//    
//    func extractSectionMarkers(_ cdSectionMarkers: NSSet?) -> [Marker] {
//        var arMarkers = [Marker]()
//        guard let cdSectionMarkers = cdSectionMarkers else {
//            return arMarkers
//        }
//        
//        for cdSectionMarker in cdSectionMarkers {
//            arMarkers.append(SectionMarkerDA().parseFromCoreData(cdSectionMarker as! CDSectionMarker))
//        }
//        return arMarkers
//    }
//    
//}
