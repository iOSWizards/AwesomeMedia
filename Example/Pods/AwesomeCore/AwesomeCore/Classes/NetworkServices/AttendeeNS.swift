//
//  AttendeeNS.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 6/18/18.
//

import Foundation

class AttendeeNS {
    
    static let shared = AttendeeNS()
    lazy var requester: AwesomeCoreRequester = AwesomeCoreRequester(cacheType: .realm)
    var currentPage: Int = 1
    
    init() {}
    
    var requests = [String: URLSessionDataTask]()
    
    func fetchAttendees(eventSlug: EventCode, isFirstPage: Bool = true, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Attendee], ErrorData?) -> Void) {
        
        if isFirstPage {
            currentPage = 1
        }
        
        var didRespondCachedData = false
        
        func processResponse(data: Data?, response: @escaping ([Attendee], ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            let attendees = AttendeeMP.parseAttendeesFrom(data)
            response(attendees, nil)
            
            return attendees.count > 0
        }
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.eventsAttendeesURL, with: eventSlug.rawValue, "\(currentPage)")
        
        func fetchFromAPI(forceUpdate: Bool) {
            
            // cancel previews request only if should
            if params.contains(.canCancelRequest) {
                requests[url]?.cancel()
                requests[url] = nil
            }
            
            requests[url] = requester.performRequestAuthorized(
                url, forceUpdate: forceUpdate, method: .GET, completion: { (data, error, responseType) in
                    self.requests[url] = nil
                    
                    //process response
                    let hasResponse = processResponse(data: data, response: response)
                    if hasResponse {
                         self.currentPage += 1
                    }
                    
                    //fetches again based on response type
                    if !forceUpdate && responseType == .cached {
                        didRespondCachedData = hasResponse
                        
                        fetchFromAPI(forceUpdate: true)
                    } else if let error = error {
                        print("Error fetching from API: \(error.message)")
                        
                        if !didRespondCachedData {
                            response([], error)
                        }
                    }
            })
        }
        
        // fetches from cache if the case
        if params.contains(.shouldFetchFromCache) {
            fetchFromAPI(forceUpdate: false)
        } else {
            fetchFromAPI(forceUpdate: true)
        }
    }
    
    func fetchFilteredAttendeesByTag(eventSlug: EventCode, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Attendee], ErrorData?) -> Void) {
        
        var didRespondCachedData = false
        
        func processResponse(data: Data?, response: @escaping ([Attendee], ErrorData?) -> Void ) -> Bool {
            guard let data = data else {
                return false
            }
            
            let attendees = AttendeeMP.parseAttendeesFrom(data)
            response(attendees, nil)
            
            return attendees.count > 0
        }
        
        let url = ACConstants.buildURLWith(format: ACConstants.shared.eventsAttendeesByTagURL, with: eventSlug.rawValue)
        
        func fetchFromAPI(forceUpdate: Bool) {
            
            // cancel previews request only if should
            if params.contains(.canCancelRequest) {
                requests[url]?.cancel()
                requests[url] = nil
            }
            
            requests[url] = requester.performRequestAuthorized(
                url, forceUpdate: forceUpdate, method: .GET, completion: { (data, error, responseType) in
                    self.requests[url] = nil
                    
                    //process response
                    let hasResponse = processResponse(data: data, response: response)
                    
                    //fetches again based on response type
                    if !forceUpdate && responseType == .cached {
                        didRespondCachedData = hasResponse
                        
                        fetchFromAPI(forceUpdate: true)
                    } else if let error = error {
                        print("Error fetching from API: \(error.message)")
                        
                        if !didRespondCachedData {
                            response([], error)
                        }
                    }
            })
        }
        
        // fetches from cache if the case
        if params.contains(.shouldFetchFromCache) {
            fetchFromAPI(forceUpdate: false)
        } else {
            fetchFromAPI(forceUpdate: true)
        }
    }
}
