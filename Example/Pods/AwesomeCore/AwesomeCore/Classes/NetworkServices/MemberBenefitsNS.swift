//
//  MemberBenefitsNS.swift
//  AwesomeCore
//
//  Created by Emmanuel on 09/05/2018.
//

import Foundation

class MemberBenefitsNS {
    
    static let shared = MemberBenefitsNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var memberBenefitsRequest: URLSessionDataTask?
    
    func fetchMemberBenefits(forcingUpdate: Bool = false, response: @escaping ([Benefits], ErrorData?) -> Void) {
        
        memberBenefitsRequest?.cancel()
        memberBenefitsRequest = nil
        
        memberBenefitsRequest = awesomeRequester.performRequestAuthorized(
            ACConstants.shared.memberBenefits, forceUpdate: forcingUpdate, method: .GET, completion: { (data, error, responseType) in
                
                if let jsonObject = data {
                    self.memberBenefitsRequest = nil
                    response(MemberBenefitsMP.parseMemberBenefitsFrom(jsonObject).benefits, nil)
                } else {
                    self.memberBenefitsRequest = nil
                    if let error = error {
                        response([], error)
                        return
                    }
                    response([], ErrorData(.unknown, "response Data for Member Benefits could not be parsed"))
                }
        })
    }
}
