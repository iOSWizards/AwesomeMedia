//
//  SeriesBO.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/05/18.
//

import Foundation

public struct SeriesBO {
    
    static var seriesNS = SeriesNS.shared
    public static var shared = SeriesBO()
    
    private init() {}
    
    public static func fetchSerie(with academyId: Int, serieId: Int, forcingUpdate: Bool = false, response: @escaping (SeriesData?, ErrorData?) -> Void) {
        seriesNS.fetchSeriesData(with: academyId, serieId: serieId, forcingUpdate: forcingUpdate, response: { (series, error) in
            DispatchQueue.main.async {
                response(series, error)
            }
        })
    }
}
