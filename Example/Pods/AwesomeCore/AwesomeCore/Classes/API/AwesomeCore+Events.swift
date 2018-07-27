//
//  AwesomeCore+Events.swift
//  Pods
//
//  Created by Evandro Harrison Hoffmann on 6/18/18.
//

import Foundation

public enum EventCode: String {
    case mvu
}

public extension AwesomeCore {
    
    public static func fetchAttendees(eventSlug: EventCode = .mvu, isFirstPage: Bool = true, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Attendee], ErrorData?) -> Void) {
        AttendeeBO.fetchAttendees(eventSlug: eventSlug, isFirstPage: isFirstPage, params: params, response: response)
    }
    
    public static func fetchFilteredAttendeesByTag(eventSlug: EventCode = .mvu, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping ([Attendee], ErrorData?) -> Void) {
        AttendeeBO.fetchFilteredAttendeesByTag(eventSlug: eventSlug, params: params, response: response)
    }
    
    public static func fetchEventPurchaseStatus(eventSlug: EventCode = .mvu, params: AwesomeCoreNetworkServiceParams = .standard, response: @escaping (Bool?, ErrorData?) -> Void) {
       EventPurchaseStatusBO.fetchPurchaseStatus(eventSlug: eventSlug, params: params, response: response)
    }
    
    public static func patchTravelDates(eventSlug: EventCode = .mvu, arrivalDate: String, departureDate: String, forcingUpdate: Bool = false, response: @escaping (Bool, ErrorData?) -> Void) {
        EventRegistrationBO.patchTravelDates(eventSlug: eventSlug, arrivalDate: arrivalDate, departureDate: departureDate, forcingUpdate: forcingUpdate, response: response)
    }
    
    public static func fetchHomeUserProfile(forcingUpdate: Bool, response: @escaping (HomeUserProfile?, ErrorData?)-> Void) {
        UserProfileBO.fetchHomeUserProfile(forcingUpdate: forcingUpdate, response: response)
    }
    
    public static func fetchPurchaseStatus(eventSlug: EventCode = .mvu, response: @escaping (PurchaseStatus?, ErrorData?)-> Void) {
        PurchaseStatusBO.fetchPurchaseStatus(eventSlug: eventSlug, params: .standard, response: response)
    }
}
