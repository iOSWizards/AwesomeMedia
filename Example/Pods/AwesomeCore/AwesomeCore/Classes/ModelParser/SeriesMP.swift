//
//  SeriesMP.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/05/18.
//

import Foundation

struct SeriesMP {
    
    static func parseSeriesFrom(_ seriesJson: Data) -> SeriesData? {
        
        if let decoded = try? JSONDecoder().decode(Series.self, from: seriesJson) {
            return decoded.serie
        } else {
            return nil
        }
    }
    
}

