//
//  HappeningsNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 26/10/17.
//

import Foundation

class HappeningsNS: BaseNS {
    
    static let shared = HappeningsNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    var lastHappeningsRequest: URLSessionDataTask?
    
    func fetchHappenings(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Happening], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([Happening], ErrorData?) -> Void ) -> Bool {
            if let jsonObject = data {
                self.lastHappeningsRequest = nil
                response(HappeningsMP.parseHappeningsFrom(jsonObject), nil)
                return true
            } else {
                self.lastHappeningsRequest = nil
                if let error = error {
                    response([Happening](), error)
                    return false
                }
                response([Happening](), ErrorData(.unknown, "response Data could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.shared.happenings
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        lastHappeningsRequest = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: nil, data: data)
                }
        })
    }
}
