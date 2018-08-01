//
//  NewTrainingsNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 05/09/17.
//

import Foundation

class NewTrainingsNS {
    
    static var shared = NewTrainingsNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    var lastNewTrainingsRequest: URLSessionDataTask?
    
    init() {}
    
    func fetchNewTrainings(forcingUpdate: Bool = false, response: @escaping ([TrainingCard], ErrorData?) -> Void) {
        
        lastNewTrainingsRequest?.cancel()
        lastNewTrainingsRequest = nil
        
        lastNewTrainingsRequest = awesomeRequester.performRequestAuthorized(ACConstants.shared.newTrainingsURL, forceUpdate: forcingUpdate) { (data, error, responseType) in
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.lastNewTrainingsRequest = nil
                response(TrainingCardMP.parseTrainingsFrom(jsonObject: jsonObject), nil)
            } else {
                self.lastNewTrainingsRequest = nil
                if let error = error {
                    response([], error)
                    return
                }
                response([], ErrorData(.unknown, "response Data could not be parsed"))
            }
        }
        
    }
    
}
