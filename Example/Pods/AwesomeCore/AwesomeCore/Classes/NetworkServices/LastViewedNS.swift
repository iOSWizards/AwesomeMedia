//
//  LastViewedNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 06/09/17.
//

import Foundation

class LastViewedNS {
    
    static var shared = LastViewedNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    var lastViewedRequest: URLSessionDataTask?
    
    init() {}
    
    func fetchLastViewed(forcingUpdate: Bool = false, response: @escaping ([TrainingCard], ErrorData?) -> Void) {
        
        lastViewedRequest?.cancel()
        lastViewedRequest = nil
        
        lastViewedRequest = awesomeRequester.performRequestAuthorized(ACConstants.shared.lastViewedURL, forceUpdate: forcingUpdate) { (data, error, responseType) in
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.lastViewedRequest = nil
                response(TrainingCardMP.parseTrainingsFrom(jsonObject: jsonObject), nil)
            } else {
                self.lastViewedRequest = nil
                if let error = error {
                    response([], error)
                    return
                }
                response([], ErrorData(.unknown, "response Data could not be parsed"))
            }
        }
        
    }
    
}

