//
//  AttendeeNS.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 6/18/18.
//

import Foundation

class AttendeeNS: BaseNS {
    
    static let shared = AttendeeNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    var currentPage: Int = 1
    
    override init() {}
    
    var requests = [String: URLSessionDataTask]()
    
    let method: URLMethod = .GET
    
    func fetchAttendees(eventSlug: EventCode, isFirstPage: Bool = true, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Attendee], ErrorData?) -> Void) {
        
        if isFirstPage {
            currentPage = 1
        }
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([Attendee], ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response([], nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response([], error)
                return false
            }
            
            let attendees = AttendeeMP.parseAttendeesFrom(data)
            response(attendees, nil)
            
            return attendees.count > 0
        }
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.eventsAttendeesURL, with: eventSlug.rawValue, "\(currentPage)")
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: self.method, bodyDict: nil, data: data)
                }
        })
        self.currentPage += 1
    }
    
    func fetchFilteredAttendeesByTag(eventSlug: EventCode, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Attendee], ErrorData?) -> Void) {
        
        func processResponse(data: Data?, error: ErrorData? = nil, response: @escaping ([Attendee], ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                response([], nil)
                return false
            }
            
            if let error = error {
                print("Error fetching from API: \(error.message)")
                response([], error)
                return false
            }
            
            let attendees = AttendeeMP.parseAttendeesFrom(data)
            response(attendees, nil)
            
            return attendees.count > 0
        }
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.eventsAttendeesByTagURL, with: eventSlug.rawValue)
        
        if params.contains(.shouldFetchFromCache) {
            _ = processResponse(data: dataFromCache(url, method: method, params: params, bodyDict: nil), response: response)
        }
        
        _ = requester.performRequestAuthorized(
            url, forceUpdate: true, method: method, completion: { (data, error, responseType) in
                if processResponse(data: data, error: error, response: response) {
                    self.saveToCache(url, method: self.method, bodyDict: nil, data: data)
                }
        })
    }
}
