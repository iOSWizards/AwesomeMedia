//
//  QuestMarkerMP.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 11/3/17.
//

import Foundation

struct QuestMarkerMP {
    
    static func parseQuestMarkersFrom(_ questMarkersJSON: Data) -> [QuestMarker] {
        
        var markers: [QuestMarker] = []
        if let decoded = try? JSONDecoder().decode(QuestMarkers.self, from: questMarkersJSON) {
            markers = decoded.markers
        }
        
        return markers
    }
    
}
