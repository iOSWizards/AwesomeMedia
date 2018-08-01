//
//  UserProfile.swift
//  AwesomeCore
//
//  Created by Antonio da Silva on 04/09/2017.
//

import Foundation

public struct UserProfile: Codable, Equatable {
    
    public let id: String?
    public let uid: String?
    public let email: String
    public let firstName: String?
    public let lastName: String?
    public let currentSignInAt: Date?
    public let lastSignInAt: Date?
    public let lastSignInIp: String?
    public let enrollmentsCount: Int?
    public let signInCount: Int?
    public let createdAt: Date?
    public let updatedAt: Date?
    public let lastReadCourse: ACCourse?
    public let lang: String?
    public let country: String?
    public let location: String?
    public let timezone: String?
    public let role: String?
    public let avatarUrl: String?

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
    
    init(
        id: String?,
        uid: String?,
        email: String,
        firstName: String?,
        lastName: String?,
        currentSignInAt: Date?,
        lastSignInAt: Date?,
        lastSignInIp: String,
        enrollmentsCount: Int?,
        signInCount: Int?,
        createdAt: Date?,
        updatedAt: Date?,
        lastReadCourse: ACCourse?,
        lang: String?,
        country: String?,
        location: String?,
        timezone: String?,
        role: String?,
        avatarUrl: String?) {
        self.id = id
        self.uid = uid
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.currentSignInAt = currentSignInAt
        self.lastSignInAt = lastSignInAt
        self.lastSignInIp = lastSignInIp
        self.enrollmentsCount = enrollmentsCount
        self.signInCount = signInCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastReadCourse = lastReadCourse
        self.lang = lang
        self.country = country
        self.location = location
        self.timezone = timezone
        self.role = role
        self.avatarUrl = avatarUrl
    }
    
    init(
        email: String,
        firstName: String?,
        lastName: String?,
        currentSignInAt: Date?,
        lastSignInAt: Date?,
        lastSignInIp: String,
        enrollmentsCount: Int?,
        signInCount: Int?,
        createdAt: Date?,
        updatedAt: Date?,
        lastReadCourse: ACCourse?) {
        self.id = nil
        self.uid = nil
        self.email = email
        self.firstName = firstName
        self.lastName = lastName
        self.currentSignInAt = currentSignInAt
        self.lastSignInAt = lastSignInAt
        self.lastSignInIp = lastSignInIp
        self.enrollmentsCount = enrollmentsCount
        self.signInCount = signInCount
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.lastReadCourse = lastReadCourse
        self.lang = nil
        self.country = nil
        self.location = nil
        self.timezone = nil
        self.role = nil
        self.avatarUrl = nil
    }
}

// MARK: - JSON Key

public struct UserProfileDataKey: Codable {
    
    public let data: UserProfileKey
    
}

public struct UserProfileKey: Codable {
    
    public let profile: UserProfile?
    
}

public struct HomeUserProfile: Codable {
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
    public let industry: String?
    public let languageName: String?
    public let country: String?
    public let city: String?
    public let location: String?
    public let dateOfBirth: String?
    public let timezone: String?
    public let needsToCreatePassword: Bool?
    public let facebookId: String?
    public let title: String?
    public let shortBio: String?
    public let discoverable: Bool?
    public let ageGroup: String?
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

public struct HomeUserProfileDataKey: Codable {
    
    public let user: HomeUserProfile
    
}

extension HomeUserProfile {
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
        case industry
        case languageName = "language_name"
        case country
        case city
        case location
        case timezone = "timezone_identifier"
        case needsToCreatePassword = "need_to_create_password"
        case facebookId = "facebook_id"
        case title
        case shortBio = "bio"
        case discoverable
        case ageGroup = "enrolment_group"
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

// MARK: - Equatable

extension UserProfile {
    
    public static func ==(lhs: UserProfile, rhs: UserProfile) -> Bool {
        if lhs.id != rhs.id {
            return false
        }
        if lhs.uid != rhs.uid {
            return false
        }
        if lhs.email != rhs.email {
            return false
        }
        if lhs.firstName != rhs.firstName {
            return false
        }
        if lhs.lastName != rhs.lastName {
            return false
        }
        if lhs.currentSignInAt != rhs.currentSignInAt {
            return false
        }
        if lhs.lastSignInAt != rhs.lastSignInAt {
            return false
        }
        if lhs.lastSignInIp != rhs.lastSignInIp {
            return false
        }
        if lhs.enrollmentsCount != rhs.enrollmentsCount {
            return false
        }
        if lhs.signInCount != rhs.signInCount {
            return false
        }
        if lhs.createdAt != rhs.createdAt {
            return false
        }
        if lhs.updatedAt != rhs.updatedAt {
            return false
        }
        if lhs.lastReadCourse != rhs.lastReadCourse {
            return false
        }
        if lhs.lang != rhs.lang {
            return false
        }
        if lhs.country != rhs.country {
            return false
        }
        if lhs.location != rhs.location {
            return false
        }
        if lhs.timezone != rhs.timezone {
            return false
        }
        if lhs.role != rhs.role {
            return false
        }
        if lhs.avatarUrl != rhs.avatarUrl {
            return false
        }
        
        return true
    }
}
