//
//  SeriesNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/05/18.
//

import Foundation

class SeriesNS {
    
    static let shared = SeriesNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var seriesRequest: URLSessionDataTask?
    
    func fetchSeriesData(with academyId: Int, serieId: Int, forcingUpdate: Bool = false, response: @escaping (SeriesData?, ErrorData?) -> Void) {
        
        seriesRequest?.cancel()
        seriesRequest = nil
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.series, with: academyId, serieId)
        
        seriesRequest = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: forcingUpdate, method: .GET, completion: { (data, error, responseType) in
                
                if let jsonObject = data {
                    self.seriesRequest = nil
                    response(SeriesMP.parseSeriesFrom(jsonObject), nil)
                } else {
                    self.seriesRequest = nil
                    if let error = error {
                        response(nil, error)
                        return
                    }
                    response(nil, ErrorData(.unknown, "response Data for Member Benefits could not be parsed"))
                }
        })
    }
}

