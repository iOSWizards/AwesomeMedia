//
//  SeriesNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 17/05/18.
//

import Foundation

class SeriesNS: BaseNS {
    
    static let shared = SeriesNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    var seriesRequest: URLSessionDataTask?
    
    func fetchSeriesData(with academyId: Int, serieId: Int, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (SeriesData?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (SeriesData?, ErrorData?) -> Void ) -> Bool {
            if let jsonObject = data {
                self.seriesRequest = nil
                response(SeriesMP.parseSeriesFrom(jsonObject), nil)
                return true
            } else {
                self.seriesRequest = nil
                if let error = error {
                    response(nil, error)
                    return false
                }
                response(nil, ErrorData(.unknown, "response Data for Member Benefits could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.series, with: academyId, serieId)
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        _ = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, method: method, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: nil, data: data)
                }
        })
    }
}

