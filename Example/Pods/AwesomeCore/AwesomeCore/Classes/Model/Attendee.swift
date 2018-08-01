//
//  Attendees.swift
//  AwesomeCore
//
//  Created by Evandro Harrison Hoffmann on 6/18/18.
//

import Foundation

public struct Attendee: Codable {
    
    public let id: Int?
    public let uid: String?
    public let email: String?
    public let photo: String?
    public let firstName: String?
    public let lastName: String?
    public let phone: String?
    public let language: String?
    public let countryName: String?
    public let gender: String?
    public let profession: String?
    public let languageName: String?
    public let country: String?
    public let location: String?
    public let dateOfBirth: String?
    public let timezone: String?
    public let needsToCreatePassword: Bool?
    public let facebookId: String?
    public let title: String?
    public let shortBio: String?
    public let discoverable: Bool?
    public let website: String?
    public let linkedin: String?
    public let facebook: String?
    public let twitter: String?
    public let tags: [String]?
    public let metaTags: [String]?
    public let eventTags: [Int]?
    private let eventRegistrationsPriv: [EventRegistrationKey]?
    
    public var name: String {
        var name = ""
        
        if let firstName = firstName, firstName.count > 0 {
            name.append(firstName)
        }
        
        if let lastName = lastName, lastName.count > 0 {
            name.append(" \(lastName)")
        }
        
        return name
    }
    
    public var eventRegistrations: [EventRegistration] {
        if let eventRegistrationsPriv = eventRegistrationsPriv {
            return eventRegistrationsPriv.map { registration in
                registration.eventRegistration
            }
        }
        return []
    }
        
}

public struct EventRegistration: Codable {
    public let id: Int?
    public let eventName: String?
    public let eventBizzaboId: Int?
    public let arrivalDate: String?
    public let departureDate: String?
}

public struct EventRegistrationKey: Codable {
    public let eventRegistration: EventRegistration
    
    private enum CodingKeys: String, CodingKey {
        case eventRegistration = "event_registration"
    }
}

public struct AttendeeUserKey: Codable {
    public let user: Attendee
}

// MARK: - Coding keys

extension Attendee {
    private enum CodingKeys: String, CodingKey {
        case id
        case uid
        case email
        case photo = "profile_photo_url"
        case firstName = "first_name"
        case lastName = "last_name"
        case phone
        case language = "lang"
        case countryName = "country_name"
        case dateOfBirth = "date_of_birth"
        case gender
        case profession
        case languageName = "language_name"
        case country
        case location
        case timezone = "timezone_identifier"
        case needsToCreatePassword = "need_to_create_password"
        case facebookId = "facebook_id"
        case title
        case shortBio = "bio"
        case discoverable
        case website
        case linkedin = "linked_in"
        case facebook
        case twitter
        case tags
        case metaTags = "meta_tags"
        case eventTags = "event_tags"
        case eventRegistrationsPriv = "event_registrations"
    }
}

extension EventRegistration {
    private enum CodingKeys: String, CodingKey {
        case id
        case eventName = "event_name"
        case eventBizzaboId = "event_bizzabo_id"
        case arrivalDate = "arrival_date"
        case departureDate = "departure_date"
    }
}

