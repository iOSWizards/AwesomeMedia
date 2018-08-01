//
//  EventRegistrationBO.swift
//  Pods
//
//  Created by Leonardo Vinicius Kaminski Ferreira on 26/06/18.
//

import Foundation

public struct EventRegistrationBO {
    
    static var eventRegistrationNS = EventRegistrationNS.shared
    public static var shared = EventRegistrationBO()
    
    private init() {}
    
    public static func patchTravelDates(eventSlug: EventCode, arrivalDate: String, departureDate: String, forcingUpdate: Bool = false, response: @escaping (Bool, ErrorData?) -> Void) {
        eventRegistrationNS.patchTravelDates(eventSlug: eventSlug, arrivalDate: arrivalDate, departureDate: departureDate, forcingUpdate: forcingUpdate) { (status, error) in
            DispatchQueue.main.async {
                response(status, error)
            }
        }
    }
}
