//
//  AttendeeBO.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 6/18/18.
//

import Foundation

public struct AttendeeBO {
    
    static var attendeeNS = AttendeeNS.shared
    public static var shared = AttendeeBO()
    
    private init() {}
    
    public static func fetchAttendees(eventSlug: EventCode, isFirstPage: Bool = true, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Attendee], ErrorData?) -> Void) {
        attendeeNS.fetchAttendees(eventSlug: eventSlug, isFirstPage: isFirstPage, params: params) { (attendees, error) in
            DispatchQueue.main.async {
                response(attendees, error)
            }
        }
    }
    
    public static func fetchFilteredAttendeesByTag(eventSlug: EventCode, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Attendee], ErrorData?) -> Void) {
        attendeeNS.fetchFilteredAttendeesByTag(eventSlug: eventSlug, params: params) { (attendees, error) in
            DispatchQueue.main.async {
                response(attendees, error)
            }
        }
    }
}
