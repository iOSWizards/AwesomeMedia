//
//  AcademyNS.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 30/08/2017.
//

import Foundation

enum AcademyTypedAs: String {
    case collection = "collection"
    case subscription = "subscription"
}

class AcademyNS: BaseNS {
    
    static let shared = AcademyNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    override init() {}
    
    var lastAcademiesRequest: URLSessionDataTask?
    var lastAcademyRequest: URLSessionDataTask?
    var lastMembershipAcademiesRequest: URLSessionDataTask?
    
    var lastAcademiesAsCollectionsRequest,
    lastAcademiesAsSubscriptionsRequest: URLSessionDataTask?
    
    func fetchAcademies(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([ACAcademy], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([ACAcademy], ErrorData?) -> Void ) -> Bool {
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.lastAcademiesRequest = nil
                response(AcademyMP.parseAcademiesFrom(jsonObject, key: "academies"), nil)
                return true
            } else {
                self.lastAcademiesRequest = nil
                if let error = error {
                    response([ACAcademy](), error)
                    return false
                }
                response([ACAcademy](), ErrorData(.unknown, "response Data could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.shared.academiesURL
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        lastAcademiesRequest = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: nil, data: data)
                }
        })
    }
    
    func fetchMembershipAcademies(params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([MembershipAcademy], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([MembershipAcademy], ErrorData?) -> Void ) -> Bool {
            if let jsonObject = data {
                self.lastMembershipAcademiesRequest = nil
                response(MembershipAcademiesMP.parseMembershipAcademiesFrom(jsonObject), nil)
                return true
            } else {
                self.lastMembershipAcademiesRequest = nil
                if let error = error {
                    response([MembershipAcademy](), error)
                    return false
                }
                response([MembershipAcademy](), ErrorData(.unknown, "response Data could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.shared.membershipAcademies
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        lastMembershipAcademiesRequest = awesomeRequester.performRequestAuthorized(
            url, forceUpdate: true, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: method, bodyDict: nil, data: data)
                }
        })
    }
    
    func fetchAcademy(usingAcademy: Int, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (ACAcademy?, ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping (ACAcademy?, ErrorData?) -> Void ) -> Bool {
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject],
                let academyJson = jsonObject["academy"] as? [String: AnyObject] {
                self.lastAcademyRequest = nil
                response(AcademyMP.parseAcademyFrom(academyJson), nil)
                return true
            } else {
                self.lastAcademyRequest = nil
                if let error = error {
                    response(nil, error)
                    return false
                }
                response(nil, ErrorData(.unknown, "response Data could not be parsed"))
                return false
            }
        }
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.academyURL, with: usingAcademy)
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        lastAcademyRequest = awesomeRequester.performRequestAuthorized(url, forceUpdate: true, completion: { (data, error, responseType) in
            if processResponse(data: data, error: error, response: response) {
                self.saveToCache(url, method: method, bodyDict: nil, data: data)
            }
        })
    }
    
    func fetchAcademiesTypedAs(_ academyType: AcademyTypedAs, itemsPerPage: Int, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([ACAcademy], Int?, ErrorData?, AwesomeResponseType) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, responseType: AwesomeResponseType, response: @escaping ([ACAcademy], Int?, ErrorData?, AwesomeResponseType) -> Void ) -> Bool {
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                
                academyType == .collection ?
                    (self.lastAcademiesAsCollectionsRequest = nil) : (self.lastAcademiesAsSubscriptionsRequest = nil)
                let paginationData = PaginationDataMP.parsePaginationFrom(jsonObject, key: "meta")
                response(AcademyMP.parseAcademiesFrom(jsonObject, key: "academies"), paginationData?.total, nil, responseType)
                return true
            } else {
                if let error = error {
                    response([ACAcademy](), nil, error, responseType)
                    return false
                }
                response([ACAcademy](), nil, ErrorData(.unknown, "response Data could not be parsed"), responseType)
                return false
            }
        }
        
        let url = ACConstants.buildURLWith(
            format: ACConstants.shared.academiesTypedURL,
            with: academyType.rawValue,
            String(itemsPerPage)
        )
        let method: URLMethod = .GET
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), responseType: .cached, response: response)
        }
        
        _ = awesomeRequester.performRequestAuthorized(url, forceUpdate: true, completion: { (data, error, responseType) in
            if processResponse(data: data, error: error, responseType: .fromServer, response: response) {
                self.saveToCache(url, method: method, bodyDict: nil, data: data)
            }
        })
    }
}
