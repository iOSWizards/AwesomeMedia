//
//  MemberBenefitsNS.swift
//  AwesomeCore
//
//  Created by Emmanuel on 09/05/2018.
//

import Foundation

class MemberBenefitsNS: BaseNS {
    
    static let shared = MemberBenefitsNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    var memberBenefitsRequest: URLSessionDataTask?
    
    func fetchMemberBenefits(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Benefits], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([Benefits], ErrorData?) -> Void ) -> Bool {
            if let jsonObject = data {
                self.memberBenefitsRequest = nil
                response(MemberBenefitsMP.parseMemberBenefitsFrom(jsonObject).benefits, nil)
                return true
            } else {
                self.memberBenefitsRequest = nil
                if let error = error {
                    response([], error)
                    return false
                }
                response([], ErrorData(.unknown, "response Data for Member Benefits could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.shared.memberBenefits
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
