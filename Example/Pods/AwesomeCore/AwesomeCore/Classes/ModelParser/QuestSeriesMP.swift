//
//  QuestChannelMP.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 7/23/18.
//

import Foundation

struct QuestSeriesMP {
    
    static func parseSerieFrom(_ json: Data) -> QuestSeries? {
        var serie: QuestSeries?
        do {
            let decoded = try JSONDecoder().decode(SingleQuestSeriesDataKey.self, from: json)
            serie = decoded.data.series
        } catch {
            print("\(#function) error: \(error)")
        }
        return serie
    }
    
}
