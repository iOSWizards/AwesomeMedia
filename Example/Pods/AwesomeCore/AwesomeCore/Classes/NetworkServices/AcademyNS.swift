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

class AcademyNS {
    
    static let shared = AcademyNS()
    lazy var awesomeRequester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    
    init() {}
    
    var lastAcademiesRequest: URLSessionDataTask?
    var lastAcademyRequest: URLSessionDataTask?
    var lastMembershipAcademiesRequest: URLSessionDataTask?
    
    var lastAcademiesAsCollectionsRequest,
    lastAcademiesAsSubscriptionsRequest: URLSessionDataTask?
    
    func fetchAcademies(forcingUpdate: Bool = false, response: @escaping ([ACAcademy], ErrorData?) -> Void) {
        
        lastAcademiesRequest?.cancel()
        lastAcademiesRequest = nil
        
        lastAcademiesRequest = awesomeRequester.performRequestAuthorized(
            ACConstants.shared.academiesURL, forceUpdate: forcingUpdate, completion: { (data, error, responseType) in
                
                if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                    self.lastAcademiesRequest = nil
                    response(AcademyMP.parseAcademiesFrom(jsonObject, key: "academies"), nil)
                } else {
                    self.lastAcademiesRequest = nil
                    if let error = error {
                        response([ACAcademy](), error)
                        return
                    }
                    response([ACAcademy](), ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
    
    func fetchMembershipAcademies(forcingUpdate: Bool = false, response: @escaping ([MembershipAcademy], ErrorData?) -> Void) {
        
        lastMembershipAcademiesRequest?.cancel()
        lastMembershipAcademiesRequest = nil
        
        lastMembershipAcademiesRequest = awesomeRequester.performRequestAuthorized(
            ACConstants.shared.membershipAcademies, forceUpdate: forcingUpdate, completion: { (data, error, responseType) in
                
                if let jsonObject = data {
                    self.lastMembershipAcademiesRequest = nil
                    response(MembershipAcademiesMP.parseMembershipAcademiesFrom(jsonObject), nil)
                } else {
                    self.lastMembershipAcademiesRequest = nil
                    if let error = error {
                        response([MembershipAcademy](), error)
                        return
                    }
                    response([MembershipAcademy](), ErrorData(.unknown, "response Data could not be parsed"))
                }
        })
    }
    
    func fetchAcademy(usingAcademy: Int, forcingUpdate: Bool = false, response: @escaping (ACAcademy?, ErrorData?) -> Void) {
        
        lastAcademyRequest?.cancel()
        lastAcademyRequest = nil
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.academyURL, with: usingAcademy)  
        
        lastAcademyRequest = awesomeRequester.performRequestAuthorized(url, forceUpdate: forcingUpdate, completion: { (data, error, responseType) in
            
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                self.lastAcademyRequest = nil
                response(AcademyMP.parseAcademyFrom(jsonObject), nil)
            } else {
                self.lastAcademyRequest = nil
                if let error = error {
                    response(nil, error)
                    return
                }
                response(nil, ErrorData(.unknown, "response Data could not be parsed"))
            }
        })
    }
    
    func fetchAcademiesTypedAs(_ academyType: AcademyTypedAs, itemsPerPage: Int, forcingUpdate: Bool = false, response: @escaping ([ACAcademy], ErrorData?) -> Void) {
        
        if academyType == .collection {
            lastAcademiesAsCollectionsRequest?.cancel()
            lastAcademiesAsCollectionsRequest = nil
        } else {
            lastAcademiesAsSubscriptionsRequest?.cancel()
            lastAcademiesAsSubscriptionsRequest = nil
        }
        
        let url = ACConstants.buildURLWith(
            format: ACConstants.shared.academiesTypedURL,
            with: academyType.rawValue,
            String(itemsPerPage)
        )
        
        let tmpRequest = awesomeRequester.performRequestAuthorized(url, forceUpdate: forcingUpdate, completion: { (data, error, responseType) in
            
            if let jsonObject = AwesomeCoreParser.jsonObject(data) as? [String: AnyObject] {
                
                academyType == .collection ?
                    (self.lastAcademiesAsCollectionsRequest = nil) : (self.lastAcademiesAsSubscriptionsRequest = nil)
                
                response(AcademyMP.parseAcademiesFrom(jsonObject, key: "academies"), nil)
            } else {
                
                academyType == .collection ?
                    (self.lastAcademiesAsCollectionsRequest = nil) : (self.lastAcademiesAsSubscriptionsRequest = nil)
                
                if let error = error {
                    response([ACAcademy](), error)
                    return
                }
                response([ACAcademy](), ErrorData(.unknown, "response Data could not be parsed"))
            }
        })
        
        if academyType == .collection {
            lastAcademiesAsCollectionsRequest = tmpRequest
        } else {
            lastAcademiesAsSubscriptionsRequest = tmpRequest
        }
        
    }
}
