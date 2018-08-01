//
//  HappeningsNS.swift
//  AwesomeCore
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 26/10/17.
//

import Foundation

class HappeningsNS {
    
    static let shared = HappeningsNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var lastHappeningsRequest: URLSessionDataTask?
    
    func fetchHappenings(forcingUpdate: Bool = false, response: @escaping ([Happening], ErrorData?) -> Void) {
        
        lastHappeningsRequest?.cancel()
        lastHappeningsRequest = nil
        
        lastHappeningsRequest = awesomeRequester.performRequestAuthorized(
            ACConstants.shared.happenings, forceUpdate: forcingUpdate, completion: { (data, error, responseType) in
                
                if let jsonObject = data {
                    self.lastHappeningsRequest = nil
                    response(HappeningsMP.parseHappeningsFrom(jsonObject), nil)
                } else {
                    self.lastHappeningsRequest = nil
                    if let error = error {
                        response([Happening](), error)
                        return
                    }
                    response([Happening](), ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
}
