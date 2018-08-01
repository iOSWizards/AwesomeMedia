//
//  EventRegistrationNS.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 26/06/18.
//

import Foundation

class EventRegistrationNS {
    
    static let shared = EventRegistrationNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var eventRegistrationRequest: URLSessionDataTask?
    
    func patchTravelDates(eventSlug: EventCode, arrivalDate: String, departureDate: String, forcingUpdate: Bool = false, response: @escaping (Bool, ErrorData?) -> Void) {
        
        eventRegistrationRequest?.cancel()
        eventRegistrationRequest = nil
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.eventRegistrationURL, with: eventSlug.rawValue, arrivalDate, departureDate)
        eventRegistrationRequest = awesomeRequester.performRequestAuthorized(
            url.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed), forceUpdate: forcingUpdate, method: .PATCH, completion: { (data, error, responseType) in
                
                if error == nil {
                    self.eventRegistrationRequest = nil
                    response(true, nil)
                } else {
                    self.eventRegistrationRequest = nil
                    if let error = error {
                        response(false, error)
                        return
                    }
                    response(false, ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
}
