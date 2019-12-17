//
//  NewTrainingsNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 05/09/17.
//

import Foundation

class NewTrainingsNS: BaseNS {
    
    static var shared = NewTrainingsNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    var lastNewTrainingsRequest: URLSessionDataTask?
    
    override init() {}
    
    func fetchNewTrainings(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([TrainingCard], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([TrainingCard], ErrorData?) -> Void ) -> Bool {
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.lastNewTrainingsRequest = nil
                response(TrainingCardMP.parseTrainingsFrom(jsonObject: jsonObject), nil)
                return true
            } else {
                self.lastNewTrainingsRequest = nil
                if let error = error {
                    response([], error)
                    return false
                }
                response([], ErrorData(.unknown, "response Data could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.shared.newTrainingsURL
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        _ = awesomeRequester.performRequestAuthorized(url, forceUpdate: true) { (data, error, responseType) in
            if processResponse(data: data, error: error, response: response) {
                self.saveToCache(url, method: method, bodyDict: nil, data: data)
            }
        }
        
    }
    
}
